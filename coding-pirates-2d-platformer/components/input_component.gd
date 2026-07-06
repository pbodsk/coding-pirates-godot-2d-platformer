class_name InputComponent
extends Node

var horizontal_direction: float = 0.0

func _process(delta: float) -> void:
	horizontal_direction = Input.get_axis("left", "right")
