extends CharacterBody2D

@export_subgroup("Nodes")
@export var animation_component: AnimationComponent
@export var gravity_component: GravityComponent
@export var horizontal_movement_component: HorizontalMovementComponent
@export var input_component: InputComponent
@export var jump_component: JumpComponent
@export var shoot_component: ShootComponent

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	horizontal_movement_component.handle_horizontal_movement(self, input_component.horizontal_direction)
	jump_component.handle_jump(self, input_component.jump_was_pressed())
	move_and_slide()
	
func _process(delta: float) -> void:
	animation_component.handle_move_animation(input_component.horizontal_direction)
	animation_component.handle_jump_animation(gravity_component.is_jumping, gravity_component.is_falling)
	
	if input_component.shoot_was_pressed():
		var direction = Vector2.LEFT if animation_component.get_sprite_direction() == -1 else Vector2.RIGHT
		shoot_component.handle_shoot_requested(position, direction, Vector2(16, 0))
