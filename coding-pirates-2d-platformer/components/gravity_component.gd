class_name GravityComponent
extends Node

@export_subgroup("Settings")
@export var gravity: float = 100

func handle_gravity(body: CharacterBody2D) -> void:
	if not body.is_on_floor():
		body.velocity.y += gravity
