extends CharacterBody2D

@export_subgroup("Nodes")
@export var animation_component: AnimationComponent
@export var edge_detection_component: EdgeDetectionComponent
@export var gravity_component: GravityComponent
@export var health_component: HealthComponent
@export var horizontal_movement_component: HorizontalMovementComponent
@export var movement_detection_component: MovementDetectionComponent
@export var shoot_component: ShootComponent

var current_movement_direction: float = -1
var previous_movement_direction: float = current_movement_direction
var is_dying: bool = false
var player_detected: bool = false

func _ready() -> void:
	horizontal_movement_component.speed = 50
	is_dying = false
	add_to_group("Enemy")
	
func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	
	handle_player_detection()
	
	if not player_detected:
		current_movement_direction = edge_detection_component.handle_edge_detection(current_movement_direction)
	else:
		# Der er en player i nærheden...skyd!
		
		# først finder vi ud af retningen mellem walker og player
		var new_direction = movement_detection_component.direction_to_target(self)
		
		# og så skyder vi!
		shoot_component.handle_burst_shoot_requested(global_position, new_direction, Vector2(32, 0), "Player")
		
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
	
func handle_player_detection() -> void:
	# Der er et target og vi kan ikke behandlet det endnu
	# Let's go!
	if movement_detection_component.has_target() and not player_detected:
		# Registrer at vi er ved at vende os
		player_detected = true

		var new_direction = movement_detection_component.direction_to_target(self)
		
		# Gem den gamle retning
		previous_movement_direction = current_movement_direction
				
		# Stå stille
		current_movement_direction = 0

		# Vend os rigtigt
		if new_direction.x < 0:
			animation_component.handle_horizontal_flip(-1)
		elif new_direction.x > 0:
			animation_component.handle_horizontal_flip(1)
						
	# Target er væk igen og det er første loop
	# siden det forsvandt, vi nulstiller
	elif !movement_detection_component.has_target() and player_detected:
		# Nulstil værdier
		player_detected = false
		current_movement_direction = previous_movement_direction
		
func die() -> void:
	# flip is_dying så vi ikke ryger i _process igen
	is_dying = true
	
	# stop så vi ikke går videre
	current_movement_direction = 0
	
	# gør så player kan løbe igennem animationen
	set_physics_process(false)
	
	# vent på at die animationen spiller færdig
	await animation_component.handle_die_animation()
	
	# og ryd pænt op
	queue_free()
