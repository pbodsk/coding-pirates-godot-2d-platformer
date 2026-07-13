class_name ShootComponent
extends Node

@export_subgroup("Nodes")
@export var bullet_scene: PackedScene
@export var shoot_cooldown_period: float = 0.5

var can_shoot: bool = true

func handle_shoot_requested(pos: Vector2, dir: Vector2, offset: Vector2) -> void:
	# må vi overhovedet skyde?
	if not can_shoot:
		# næh...nå men så stopper vi da bare her!
		return
		
	# lav en ny bullet
	var bullet = bullet_scene.instantiate()
	
	# og sæt den op med de rigtige værdier
	bullet.add(pos, dir, offset)
	
	# og smid den i view hierakiet
	get_tree().root.add_child(bullet)
	
	# sørg for at vi ikke kan skyde med det samme
	can_shoot = false
	
	# vent!
	await get_tree().create_timer(shoot_cooldown_period).timeout
	# og sig at nu kan vi skyde igen
	can_shoot = true
