class_name Tile
extends Node2D

var stone_scene = preload("res://Map/Stone.tscn")
var _mesh : MeshInstance2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_mesh = get_node("BGMesh")
	_generate_tile_env()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_tile_size()-> Vector2:
	return _mesh.scale

func _generate_tile_env() -> void:
	# Generate some stones
	var _stone_count = MapGenerator.rng.randi_range(5,10)
	
	for i in range(_stone_count):
		var _stone = stone_scene.instantiate()
		add_child(_stone)
		_stone.position = MapGenerator._random_stone_pos(self)
		MapGenerator.stones.push_back(_stone)
	
	pass
