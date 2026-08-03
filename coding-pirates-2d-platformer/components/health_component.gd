class_name HealthComponent
extends Node

@export_category("Settings")
@export var max_health: int = 3

var health: int = max_health

func hit(damage: int) -> void:
	health -= damage
	
func increase(value: int) -> void:
	# Sæt health = det mindste tal af
	# max_health 
	# og
	# health + value
	health = min(max_health, health + value)
	
func is_dead() -> bool:
	return health <= 0
