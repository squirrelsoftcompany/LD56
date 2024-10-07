extends Node

@export var mole_curve : Curve
@export var ant_curve : Curve
@export var bird_curve : Curve

@export var _max_mole_distance = 1000
@export var _max_ant_distance = 1000
@export var _max_bird_distance = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var _nearest_mole_distance = _max_mole_distance
	var _nearest_ant_distance = _max_ant_distance
	var _nearest_bird_distance = _max_bird_distance
	var _screen_center_position = get_viewport().get_camera_2d().get_screen_center_position()
	for _mole in MapGenerator.moles:
		var _distance = _screen_center_position.distance_to(_mole.global_position)
		if _distance < _nearest_mole_distance:
			_nearest_mole_distance =_distance
			
	for _ant in MapGenerator.ants:
		var _distance = _screen_center_position.distance_to(_ant.global_position)
		if _distance < _nearest_ant_distance:
			_nearest_ant_distance =_distance
			
	for _bird in MapGenerator.birds:
		var _distance = _screen_center_position.distance_to(_bird.global_position) 
		if _distance < _nearest_bird_distance:
			_nearest_bird_distance =_distance

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Mole"), mole_curve.sample((1 - _nearest_mole_distance/_max_mole_distance))*80 - 80)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ant"), ant_curve.sample((1 - _nearest_ant_distance/_max_ant_distance))*80 - 80)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Bird"),(bird_curve.sample(1 - _nearest_bird_distance/_max_bird_distance))*80 - 80)
	
	pass
