class_name Tile
extends Node2D

var stone_scenes = [preload("res://Scenes/Map/Elements/stone_1.tscn"),\
					preload("res://Scenes/Map/Elements/stone_2.tscn"),\
					preload("res://Scenes/Map/Elements/stone_3.tscn"),\
					preload("res://Scenes/Map/Elements/stone_4.tscn")]

var food_scene = preload("res://Scenes/Map/Elements/food.tscn")
var _mesh : MeshInstance2D

@export var initial_stone_count_min_max : Vector2i = Vector2i(5,10)
@export var initial_food_count_min_max:  Vector2i = Vector2i(80,100)

@export var food_timer_spawn = 10
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
		food_timer_counter = food_timer_spawn
	pass
	
func get_tile_size()-> Vector2:
	return _mesh.scale

func _generate_tile_env() -> void:
	# Generate some stones
	var _stone_count = MapGenerator.rng.randi_range(initial_stone_count_min_max.x,initial_stone_count_min_max.y)
	for i in range(_stone_count):
		var _stone_index = MapGenerator.rng.randi_range(0,stone_scenes.size()-1)
		var _stone = stone_scenes[_stone_index].instantiate()
		add_child(_stone)
		_stone.position = MapGenerator._random_stone_pos(self)
		MapGenerator.stones.push_back(_stone)
		
	# Generate some foods
	var _food_count = MapGenerator.rng.randi_range(initial_food_count_min_max.x,initial_food_count_min_max.y)
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
