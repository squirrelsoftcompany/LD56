extends Node


@export var stones : Array[Node]
@export var stone_spawn_radius : float
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _random_stone_pos(tile : Tile) -> Vector2:
	var _valid = false
	var _stone_radius = 20 #Should be transform to a custome variable
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
