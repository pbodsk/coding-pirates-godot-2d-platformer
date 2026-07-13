class_name JumpComponent
extends Node

@export_subgroup("Settings")
@export var jump_velocity: float = -350.0

func handle_jump(body: CharacterBody2D, jump_requested: bool) -> void:
	if jump_requested and body.is_on_floor():
		body.velocity.y = jump_velocity
