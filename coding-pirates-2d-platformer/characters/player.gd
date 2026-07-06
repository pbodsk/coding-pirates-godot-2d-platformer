extends CharacterBody2D

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var horizontal_movement_component: HorizontalMovementComponent
@export var input_component: InputComponent

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self)
	horizontal_movement_component.handle_horizontal_movement(self, input_component.horizontal_direction)
	move_and_slide()
