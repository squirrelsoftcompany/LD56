extends Node2D

const FOOD_RAY_LENGTH = 5 # Short ray for stone X food spacing 

@export var stones : Array[Node]
@export var foods: Array[Node]
@export var stone_spawn_radius : float
var rng = RandomNumberGenerator.new()
var _stone_radius = 20 #Should be transform to a custome variable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	


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
			if (abs(_stone.global_position.x - _new_stone_global_position.x) < stone_spawn_radius
			or	abs(_stone.global_position.y - _new_stone_global_position.y) < stone_spawn_radius):
				_valid = false
	return _new_stone_position
	
func _random_food_pos(tile : Tile) -> Vector2:
	var _valid = false
	var _new_food_position : Vector2
	var _new_food_global_position : Vector2
	
	while not _valid:
		var width = tile.get_tile_size().x
		var height = tile.get_tile_size().y
		_new_food_position.x = rng.randf_range(-width/2 + _stone_radius, width/2 - _stone_radius)
		_new_food_position.y = rng.randf_range(-height/2 + _stone_radius, height/2 - _stone_radius)
		_valid = true
		# Use the global position to check the promiscuity with stones on the complete map
		_new_food_global_position = tile.to_global(_new_food_position)
		for _stone in stones:
			if (abs(_stone.global_position.x - _new_food_global_position.x) < stone_spawn_radius
			or	abs(_stone.global_position.y - _new_food_global_position.y) < stone_spawn_radius):
				#Additional test for stone into radius
				var space_state = get_world_2d().direct_space_state
				var origin = _stone.global_position
				var direction = _stone.global_position - _new_food_global_position
				var direction_normalized = direction.normalized()
				var end = _new_food_global_position + direction_normalized * FOOD_RAY_LENGTH
				var query = PhysicsRayQueryParameters3D.create(origin, end)
				query.collide_with_areas = true
				var result = space_state.intersect_ray(query)
				if (result.collider.is_in_group("Stone")):
					_valid = false

	return _new_food_position
