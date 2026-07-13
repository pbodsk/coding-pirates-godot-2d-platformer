extends Area2D

@export_subgroup("Properties")
@export var speed: float = 400.0

# Skal vi skyde mod venstre eller højre
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_screen_exited)

func add(pos: Vector2, dir: Vector2, offset: Vector2) -> void:
	# regn x og y ud for vores bullet
	var x_pos = pos.x + (dir.x * offset.x)
	var y_pos = pos.y + (dir.y * offset.y)
	
	# og sæt vores Bullets position ud fra de 
	# udregnede værdier
	position = Vector2(x_pos, y_pos)
	
	# gem direction
	direction = dir
	
	# hvordan skal vores animation vende?
	$AnimatedSprite2D.flip_h = dir.x < 0
	$AnimatedSprite2D.play("shoot")
	
func _physics_process(delta: float) -> void:
	position += speed * delta * direction
	
func _on_screen_exited() -> void:
	print("bye")
	queue_free()
