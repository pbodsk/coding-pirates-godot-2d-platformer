class_name EdgeDetectionComponent
extends Node

@export_subgroup("Nodes")
@export var left_edge_detector: RayCast2D
@export var right_edge_detector: RayCast2D

func handle_edge_detection(current_direction: float) -> float:
	# rammer både venstre og højre edge detector jorden?
	if left_edge_detector.is_colliding() and right_edge_detector.is_colliding():
		# ja det gjorde de, så bare gå videre i samme retning
		return current_direction
	
	# nå, vi er ved at ramme en kant
	# er det venstre kant?
	if not left_edge_detector.is_colliding():
		# ja det er det, vend om og gå mod højre
		return 1.0
	
	# det var ikke venstre kant, er det højre så?
	if not right_edge_detector.is_colliding():
		# ja det er det, vend om og gå mod venstre
		return -1.0
		
	# logisk skulle vi ikke kunne ende her så vi returnerer 
	# current_direction
	return current_direction
