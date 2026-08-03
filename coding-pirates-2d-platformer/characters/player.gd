extends CharacterBody2D

@export_subgroup("Nodes")
@export var animation_component: AnimationComponent
@export var gravity_component: GravityComponent
@export var health_component: HealthComponent
@export var horizontal_movement_component: HorizontalMovementComponent
@export var input_component: InputComponent
@export var jump_component: JumpComponent
@export var shoot_component: ShootComponent

@export_subgroup("Properties")
@export var health_bar: TextureProgressBar
@export var die_wait_period: float = 1.0

var is_dying: bool = false

func _ready() -> void:
	# Alt hvad der har med health at gøre
	health_component.max_health = 5
	health_component.health = 5
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.health
	
	is_dying = false
	add_to_group("Player")
	
func _physics_process(delta: float) -> void:		
	gravity_component.handle_gravity(self, delta)
	horizontal_movement_component.handle_horizontal_movement(self, input_component.horizontal_direction)
	jump_component.handle_jump(self, input_component.jump_was_pressed())
	move_and_slide()
	
func _process(delta: float) -> void:
	# er vi ved at dø, så bare stop her
	if is_dying:
		return
	
	# Iodater health uanset om vi er igang med at dø eller ej	
	health_bar.value = health_component.health		
	
	# Kun hvis vi okke er døde kommer vi videre her til
	# Er vi så døde i mellemtiden?
	if health_component.is_dead():
		# Ja det var vi, så kald die funktionen der
		# sørger for at vi dør pænt :)
		await die()
	else:
		animation_component.handle_move_animation(input_component.horizontal_direction)
		animation_component.handle_jump_animation(gravity_component.is_jumping, gravity_component.is_falling)
	
		if input_component.shoot_was_pressed():
			var direction = Vector2.LEFT if animation_component.get_sprite_direction() == -1 else Vector2.RIGHT
			shoot_component.handle_shoot_requested(position, direction, Vector2(16, 0), "Enemy")

func hit(damage: int) -> void:
	health_component.hit(damage)
	
func increase_health(value: int) -> void:
	health_component.increase(value)
	
func die() -> void:
	# flip is_dying så vi ikke ryger i _process igen
	is_dying = true
	
	# gør så player kan løbe igennem animationen
	set_physics_process(false)
	
	# vent på at die animationen spiller færdig
	await animation_component.handle_die_animation()
	
	# vent lige lidt
	await get_tree().create_timer(die_wait_period).timeout
	
	# Og så vis Game Over skærmen
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
