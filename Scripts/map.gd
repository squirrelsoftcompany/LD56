extends Node2D


# This script manage the tile loop

var _player_position : Vector2
var _tile_one : Tile
var _tile_two : Tile
var _center_tile : Tile
var _side_tile : Tile

@export var loop_distance : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_tile_one = get_node("Tile")
	_tile_two = get_node("Tile2")
	_center_tile = _tile_one
	_side_tile = _tile_two
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# DEBUG SECTION 
	_player_position = get_global_mouse_position() # WE SHOULD USE THE WORM POSITION BUT FOR NOW THE MOUSE GLOBAL POSITION IS OK
	# END OF DEBUG SECTION
	
	# If the player is near the border of the center tile we move the side tile to the correct position
	if (_player_position.x - _center_tile.position.x)  > loop_distance:
		_side_tile.position.x = _center_tile.position.x + _center_tile.get_tile_size().x
	elif (_player_position.x - _center_tile.position.x)  < -loop_distance:
		_side_tile.position.x = _center_tile.position.x - _center_tile.get_tile_size().x
		
	# If the player is deep inside the side tile we swap the side tile and the center tile
	if (_player_position.x - _side_tile.position.x)  < loop_distance/2.0:
		var tmp_tile = _center_tile
		_center_tile = _side_tile
		_side_tile = tmp_tile
	pass
