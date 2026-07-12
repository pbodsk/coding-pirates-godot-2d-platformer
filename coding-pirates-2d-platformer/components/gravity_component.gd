class_name GravityComponent
extends Node

@export_subgroup("Settings")
@export var gravity: float = 1000

var is_jumping: bool = false
var is_falling: bool = false

func handle_gravity(body: CharacterBody2D, delta: float) -> void:
	if not body.is_on_floor():
		body.velocity.y += gravity * delta
		
		if body.velocity.y < 0:
			# Vi flytter os opad
			is_jumping = true
			is_falling = false
		elif body.velocity.y > 0:
			# Vi falder nedad
			is_jumping = false
			is_falling = true
	else:
		is_jumping = false
		is_falling = false
		
	#print(is_jumping, " ", is_falling)
