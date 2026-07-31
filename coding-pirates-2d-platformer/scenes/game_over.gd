extends Control

@export_subgroup("Properties")
@export var try_again_button: Button

func _ready() -> void:
	try_again_button.pressed.connect(_on_try_again_pressed)

func _on_try_again_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
