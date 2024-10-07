class_name WormController
extends CharacterBody2D

@export var max_rotation_speed_in_degrees := 40 # deg/s
@export var max_forward_speed := 40 # unit/s
@export var food_detector : Node2D

var food_indicator_scene = preload("res://Scenes/Map/FoodIndicator.tscn")

var _near_foods : Array[Food]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not $Worm.dead :
		# compute rotation
		var mouse_position := get_global_mouse_position() # mouse position in world units
		var mouse_direction := (mouse_position - position).normalized()
		var rotation_scale := _compute_rotation(mouse_direction, rotation)
		rotation += delta * rotation_scale * deg_to_rad(max_rotation_speed_in_degrees)
		# compute velocity
		var forward := _get_forward_from_rotation(rotation)
		velocity = forward * max_forward_speed
		move_and_slide()
	
	# Remove bad referencies on deleted food
	var _tmp_near_foods : Array[Food]
	for _food in _near_foods:
		if is_instance_valid(_food) :
			var _direction = _food.global_position - global_position
			if _direction.length() < (food_detector.get_node("Shape").shape.radius) + 40 and _direction.length() > 70 :
				_food.show_indicator(global_position + (_direction.normalized() * 30))
				_tmp_near_foods.push_back(_food) 
			else:
				_food.hide_indicator()
	_near_foods = _tmp_near_foods
	
	# Draw food indicator or hide it if to far
	#for _food in _near_foods:
		#_food.show_indicator(global_position + (_direction.normalized() * 50))


static func _compute_rotation(target_direction : Vector2, initial_rotation: float) -> float:
	var forward := _get_forward_from_rotation(initial_rotation)
	var cosinus := forward.dot(target_direction)
	var sinus := forward.cross(target_direction)
	var rotation_scale : float = sinus if cosinus >= 0.0 else sign(sinus)
	return rotation_scale


static func _get_forward_from_rotation(rot : float) -> Vector2:
	return Vector2(cos(rot), sin(rot))


func _on_food_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Food"):
		_near_foods.push_back(area.get_parent())
	pass # Replace with function body.


#func _on_food_detector_area_exited(area: Area2D) -> void:
	#if area.is_in_group("Food"):
		#var _index = _near_foods.find(area.get_parent())
		#_near_foods[_index].hide_indicator()
		#_near_foods.remove_at(_index)
	#pass # Replace with function body.
