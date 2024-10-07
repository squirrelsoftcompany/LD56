extends CanvasLayer


@export var placeholder_string := "PLACEHOLDER"


@onready var _format : String = $GAME_OVER.text


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MapGenerator.game_over.connect(game_over)
	$GAME_OVER.visible = false
	$ButtonContainer.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func game_over():
	$GAME_OVER.text = _format.replace(placeholder_string, "%010d" % MapGenerator.worm.length)
	$GAME_OVER.visible = true
	$ButtonContainer.visible = true


func _on_restart_button_pressed() -> void:
	$Selection.stop()
	$Validation.play()
	var tween := create_tween()
	tween.tween_method(
		func(val): AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), val),
		-8.4, -80, 2)
	tween.tween_callback(get_tree().change_scene_to_file.bind("res://Scenes/Main.tscn"))
	tween.tween_callback(MapGenerator.scene_changed.emit)
	var tween2 := create_tween()
	for i in range(0,10):
		tween2.tween_property($ButtonContainer/RestartButton, "self_modulate", Color(1,1,1,0), 0.25)
		tween2.tween_property($ButtonContainer/RestartButton, "self_modulate", Color(1,1,1,1), 0.25)


func _on_restart_button_mouse_entered() -> void:
	$Selection.play()


func _on_mainmenu_button_pressed() -> void:
	$Selection.stop()
	$Validation.play()
	var tween := create_tween()
	tween.tween_method(
		func(val): AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), val),
		-8.4, -80, 2)
	tween.tween_callback(get_tree().change_scene_to_file.bind("res://Scenes/UI/MainMenu.tscn"))
	tween.tween_callback(MapGenerator.scene_changed.emit)
	var tween2 := create_tween()
	for i in range(0,10):
		tween2.tween_property($ButtonContainer/MainMenuButton, "self_modulate", Color(1,1,1,0), 0.25)
		tween2.tween_property($ButtonContainer/MainMenuButton, "self_modulate", Color(1,1,1,1), 0.25)
