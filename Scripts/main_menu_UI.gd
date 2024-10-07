extends Control


@onready var validationSound : AudioStreamPlayer = $ValidationSound
@onready var selectionSound : AudioStreamPlayer = $SelectionSound
@onready var quitButton : Button = $QuitButton
@onready var moleSound : AudioStreamPlayer = $Mole
@onready var antSound : AudioStreamPlayer  = $Ant
@onready var birdSound : AudioStreamPlayer = $Bird

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Hide quit button for web support (useless)
	if OS.has_feature("web"): 
		quitButton.visible = false
	# fix bug
	$Worm.width = 25
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
	create_tween().tween_method(
		func(val): AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), val),
		-80, -8.4, 0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	selectionSound.stop()
	validationSound.play()
	var tween := create_tween()
	tween.tween_method(
		func(val): AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), val),
		-8.4, -80, 2)
	tween.tween_callback(get_tree().change_scene_to_file.bind("res://Scenes/Main.tscn"))
	var tween2 := create_tween()
	for i in range(0,10):
		tween2.tween_property($StartButton, "self_modulate", Color(1,1,1,0), 0.25)
		tween2.tween_property($StartButton, "self_modulate", Color(1,1,1,1), 0.25)

func _on_quit_button_pressed() -> void:
	var tween := create_tween()
	tween.tween_method(
		func(val): AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), val),
		-80, -8.4, 0.5)
	tween.tween_callback(get_tree().quit)


func _on_mole_sound_pressed() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Mole"), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ant"), -80)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Bird"), -80)


func _on_ant_sound_pressed() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Mole"), -80)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ant"), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Bird"), -80)


func _on_bird_sound_pressed() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Mole"), -80)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ant"), -80)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Bird"), 0)


func _on_start_button_mouse_entered() -> void:
	selectionSound.play()


func _on_quit_button_mouse_entered() -> void:
	selectionSound.play()


func _on_mole_sound_mouse_entered() -> void:
	selectionSound.play()


func _on_ant_sound_mouse_entered() -> void:
	selectionSound.play()


func _on_bird_sound_mouse_entered() -> void:
	selectionSound.play()
