class_name InputComponent
extends Node

var horizontal_direction: float = 0.0

func _process(delta: float) -> void:
	horizontal_direction = Input.get_axis("left", "right")

func jump_was_pressed() -> bool:
	return Input.is_action_just_pressed("up")

func shoot_was_pressed() -> bool:
	return Input.is_action_just_pressed("fire")
