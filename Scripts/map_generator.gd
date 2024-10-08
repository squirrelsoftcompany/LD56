extends Node2D

const FOOD_RAY_LENGTH = 20 # Short ray for Stone X Food spacing 


# SIGNALS (It may not be the best place, but for LD jam, it's good enough)
@warning_ignore("unused_signal")
signal worm_scored(score:int)
@warning_ignore("unused_signal")
signal game_over()
@warning_ignore("unused_signal")
signal scene_changed()


@export var stones : Array[Node]
@export var foods: Array[Node]
@export var moles: Array[Node]
@export var ants: Array[Node]
@export var birds: Array[Node]
@export var worm: Node # It may not be the best place, but for LD jam, it's good enough.
@export var stone_spawn_radius : float = 300


var rng = RandomNumberGenerator.new()
var _stone_radius = 100 #Should be transform to a custome variable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_changed.connect(clean_generator)


func clean_generator():
	stones.clear()
	foods.clear()
	moles.clear()
	ants.clear()
	birds.clear()


func _random_stone_pos(tile : Tile) -> Vector2:
	var _valid = false
	var _new_stone_position : Vector2
	var _new_stone_global_position : Vector2
	
	while not _valid:
		var width = tile.get_tile_size().x
		var height = tile.get_tile_size().y
		_new_stone_position.x = rng.randf_range(-width/2 + _stone_radius, width/2 - _stone_radius)
		_new_stone_position.y = rng.randf_range(-height/2 + _stone_radius, height/2 - _stone_radius)
		_valid = true
		# Use the global position to check the promiscuity of stones on the complete map
		_new_stone_global_position = tile.to_global(_new_stone_position)
		for _stone in stones:
			if (_stone.global_position - _new_stone_global_position).length() < stone_spawn_radius:
				_valid = false
	return _new_stone_position
	
func _random_food_pos(tile : Tile) -> Vector2:
	var _valid = false
	var _new_food_position : Vector2
	var _new_food_global_position : Vector2
	while not _valid:
		var width = tile.get_tile_size().x
		var height = tile.get_tile_size().y
		
		var _min_x = -width/2 + _stone_radius
		var _max_x = width/2 - _stone_radius
		var _min_y = -height/2 + _stone_radius
		var _max_y = height/2 - _stone_radius

		var _uniform_random_x = rng.randf()
		var _uniform_random_y = rng.randf()
		var _bias_factor = 2.0
		var _biased_random_x = pow(_uniform_random_x, 1.0)
		var _biased_random_y = pow(_uniform_random_y, _bias_factor)

		_new_food_position.x = _min_x + _biased_random_x * (_max_x - _min_x)
		_new_food_position.y = _min_y + _biased_random_y * (_max_y - _min_y)
		
		_valid = true
		# Use the global position to check the promiscuity with stones on the complete map
		_new_food_global_position = tile.to_global(_new_food_position)
		for _stone in stones:
			if (_stone.global_position - _new_food_global_position).length() < _stone_radius:
				##Additional test for stone into radius
				#var space_state = get_world_2d().direct_space_state
				#var origin = _stone.global_position
				#var direction = _stone.global_position - _new_food_global_position
				#var direction_normalized = direction.normalized()
				#var end = _new_food_global_position + direction_normalized * FOOD_RAY_LENGTH
				#var query = PhysicsRayQueryParameters2D.create(origin, end)
				#query.hit_from_inside  = true
				#query.collide_with_areas = true
				#var result = space_state.intersect_ray(query)
				#if (not result.is_empty()):
					#print("TOUCH : " + str(result["collider"]))
				#if (not result.is_empty() and result["collider"].is_in_group("Stone")):
					#_valid = false
				_valid = false
	return _new_food_position
	

func _random_ant_pos(tile : Tile) -> Vector2:
	var _valid = false
	var _new_ant_position : Vector2
	var _new_ant_global_position : Vector2
	
	while not _valid:
		var width = tile.get_tile_size().x
		var height = tile.get_tile_size().y
		_new_ant_position.x = rng.randf_range(-width/2 + _stone_radius, width/2 - _stone_radius)
		_new_ant_position.y = rng.randf_range(-height/2 + _stone_radius, height/2 - _stone_radius)
		_valid = true
		# Use the global position to check the promiscuity of stones on the complete map
		_new_ant_global_position = tile.to_global(_new_ant_position)
		for _stone in stones:
			if (_stone.global_position - _new_ant_global_position).length() < stone_spawn_radius:
				_valid = false
		for _ant in ants:
			if (_ant.global_position - _new_ant_global_position).length() < stone_spawn_radius:
				_valid = false
				
	return _new_ant_position
