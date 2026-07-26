extends CharacterBody2D

@export_subgroup("Nodes")
@export var animation_component: AnimationComponent
@export var edge_detection_component: EdgeDetectionComponent
@export var gravity_component: GravityComponent
@export var health_component: HealthComponent
@export var horizontal_movement_component: HorizontalMovementComponent

var current_movement_direction: float = -1
var is_dying: bool = false

func _ready() -> void:
	horizontal_movement_component.speed = 50
	is_dying = false
	

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	current_movement_direction = edge_detection_component.handle_edge_detection(current_movement_direction)
	horizontal_movement_component.handle_horizontal_movement(self, current_movement_direction)
	
	# Husk den her!
	move_and_slide()
	
func _process(delta: float) -> void:
	# er vi ved at dø, så bare stop her
	if is_dying:
		return
		
	# Kun hvis vi er døde kommer vi videre her til
	# Er vi så døde i mellemtiden?
	if health_component.is_dead():
		# Ja det var vi, så kald die funktionen der
		# sørger for at vi dør pænt :)
		await die()
		
	# Vi var ikke døde så vi kører bare videre
	animation_component.handle_move_animation(current_movement_direction)
	
func hit(damage: int) -> void:
	health_component.hit(damage)
	
func die() -> void:
	# flip is_dying så vi ikke ryger i _process igen
	is_dying = true
	
	# stop så vi ikke går videre
	current_movement_direction = 0
	
	# gør så player kan løbe igennem animationen
	set_physics_process(false)
	
	# vent på at die animationen spiller færdig
	await animation_component.handle_die_animationn()
	
	# og ryd pænt op
	queue_free()
