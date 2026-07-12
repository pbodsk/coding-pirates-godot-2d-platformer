class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D

func handle_horizontal_flip(horizontal_direction: float) -> void:
	if horizontal_direction == 0:
		return

	if horizontal_direction < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func handle_move_animation(horizontal_direction: float) -> void:
	handle_horizontal_flip(horizontal_direction)
	if horizontal_direction == 0:
		sprite.play("idle")
	else:
		sprite.play("walk")

func handle_jump_animation(is_jumping: bool, is_falling: bool) -> void:
	if is_jumping:
		sprite.play("jump")
	elif is_falling:
		sprite.play("fall")
