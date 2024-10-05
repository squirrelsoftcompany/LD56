class_name Tile
extends Node2D

var _mesh : MeshInstance2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_mesh = get_node("BGMesh")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_tile_size()-> Vector2:
	return _mesh.scale
