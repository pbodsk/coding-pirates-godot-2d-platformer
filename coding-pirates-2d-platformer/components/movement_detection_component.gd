class_name MovementDetectionComponent
extends Node

@export_group("Nodes")
@export var detection_area: Area2D

var target: Node2D = null

func _ready() -> void:
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)

func has_target() -> bool:
	return target != null
	
func direction_to_target(from: Node2D) -> Vector2:
	# Har vi overhovedet et target?
	if target == null:
		# Næh, nå men så bare returner 0, 0
		return Vector2.ZERO
	# Træk de to positioner fra hinanden
	# og returner en normaliseret værdi
	# altså en Vector hvor x og y begge er mellem 0 og 1
	return (target.global_position - from.global_position).normalized()		

func _refresh_target() -> void:
	var bodies = detection_area.get_overlapping_bodies()
	target = bodies[0] if bodies.size() > 0 else null
	
# Connected functions
func _on_body_entered(body: Node2D) -> void:
	target = body
	
func _on_body_exited(body: Node2D) -> void:
	if body == target:
		_refresh_target()
