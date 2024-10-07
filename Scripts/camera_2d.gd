extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = get_tree().get_first_node_in_group("WormHead").position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_tree().get_first_node_in_group("WormHead").position
	
	# zoom
	var bodies := get_tree().get_nodes_in_group("WormBody")
	var worm_pos : Vector2 = bodies[0].global_position
	var worm_width : float = bodies[0].start_width
	var distance_needed : float = 0.0
	for body : Node2D in bodies :
		DebugDraw2D.rect_filled(body.global_position, Vector2(10,10), Color.WHITE, delta)
		var current_distance := worm_pos.distance_to(body.global_position)
		if current_distance > distance_needed:
			distance_needed = current_distance
	distance_needed = distance_needed * 2 + worm_width*4 * 2
	var initial_size := get_viewport_rect().size / zoom
	var factors := Vector2(distance_needed / initial_size.x, distance_needed / initial_size.y)
	var zooming_needed = max(factors.x, factors.y)
	if not is_equal_approx(zooming_needed, 0):
		zoom /= zooming_needed
		zoom.x = clampf(zoom.x, 0.5, 4)
		zoom.y = clampf(zoom.y, 0.5, 4)
