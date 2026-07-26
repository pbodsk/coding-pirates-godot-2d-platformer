class_name HealthComponent
extends Node

@export_category("Settings")
@export var max_health: int = 3

var health: int = max_health

func hit(damage: int) -> void:
	health -= damage
	
func is_dead() -> bool:
	return health <= 0
