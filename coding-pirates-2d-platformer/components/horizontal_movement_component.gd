class_name HorizontalMovementComponent
extends Node

@export_subgroup("Settings")
@export var speed: float = 150
@export var ground_accelleration_speed = 6.0
@export var ground_decelleration_speed = 12.0

func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	var horizontal_change_speed: float = 0.0
	horizontal_change_speed = ground_accelleration_speed if direction != 0 else ground_decelleration_speed
	body.velocity.x = move_toward(body.velocity.x, direction * speed, horizontal_change_speed)
