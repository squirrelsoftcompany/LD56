class_name Tile
extends Node2D

var stone_scene = preload("res://Scenes/Map/Elements/stone_1.tscn")
var food_scene = preload("res://Scenes/Map/Elements/food.tscn")
var _mesh : MeshInstance2D

@export var food_timer_max = 10
var food_timer_counter = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_mesh = get_node("BGMesh")
	_generate_tile_env()
	pass # Replace with function body.


func _process(delta: float) -> void:
	if food_timer_counter > 0:
		food_timer_counter -= delta
	else:
		_generate_food()
		food_timer_counter = food_timer_max
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
		
	# Generate some foods
	var _food_count = MapGenerator.rng.randi_range(80,100)
	for i in range(_food_count):
		var _food = food_scene.instantiate()
		add_child(_food)
		_food.position = MapGenerator._random_food_pos(self)
		MapGenerator.foods.push_back(_food)
	pass
	
func _generate_food() -> void:
	# Generate food
	var _food = food_scene.instantiate()
	add_child(_food)
	_food.position = MapGenerator._random_food_pos(self)
	MapGenerator.foods.push_back(_food)
	pass
