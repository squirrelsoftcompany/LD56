extends Camera2D

@export var head_margin : float = 2

@onready var phantom : PhantomCamera2D = $"../PhantomCamera2D"
@onready var worm : Node2D =$"../WormController/Worm"
 
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#position = get_tree().get_first_node_in_group("WormHead").position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#position = get_tree().get_first_node_in_group("WormHead").position
	var head_pos : Vector2 = get_tree().get_first_node_in_group("WormHead").position
	
	# zoom
	var bodies : Array[Node] = get_tree().get_nodes_in_group("WormBody")
	#var distance_needed : float = 0.0
	#for body : Node2D in bodies :
		#DebugDraw2D.rect_filled(body.global_position, Vector2(10,10), Color.WHITE, delta)
		#var current_distance := worm_pos.distance_to(body.global_position)
		#if current_distance > distance_needed:
			#distance_needed = current_distance
	#distance_needed = distance_needed * 2 + worm_width*4 * 2
	var top : float = head_pos.y - (worm.length/head_margin)
	var bot : float =head_pos.y + (worm.length/head_margin)
	var left : float =head_pos.x - (worm.length/head_margin)
	var right : float =head_pos.x + (worm.length/head_margin)
	phantom.follow_targets.clear()
	for body in bodies:
		phantom.append_follow_targets(body)
		if body.global_position.y < top:
			top = body.global_position.y
		elif body.global_position.y > bot:
			bot = body.global_position.y
		if body.global_position.x < left:
			left = body.global_position.x
		elif body.global_position.x > right:
			right = body.global_position.x
	var height : float = bot - top + 25
	var width : float = right - left + 25
	var needed_ratio : float = width/height
	var initial_size : Vector2 = get_viewport_rect().size 
	var initial_ratio : float = initial_size.x /initial_size.y
	var zooming_needed : float = 1
	if needed_ratio >= initial_ratio:
		zooming_needed = initial_size.x/width
	else :
		zooming_needed = initial_size.y/height
	#var initial_size := get_viewport_rect().size / zoom
	#var factors := Vector2(distance_needed / initial_size.x, distance_needed / initial_size.y)
	#var zooming_needed = max(factors.x, factors.y)
	#if not is_equal_approx(zooming_needed, 0):
		#zoom /= zooming_needed
		#zoom.x = clampf(zoom.x, 0.25, 4)
		#zoom.y = clampf(zoom.y, 0.25, 4)
	if not is_equal_approx(zooming_needed, 0):
		zooming_needed = clampf(zooming_needed, 1, 4)
		phantom.set_zoom(Vector2(zooming_needed,zooming_needed))
