extends Area2D

@export var food_sound : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Food"):
		food_sound.play()
		MapGenerator.worm.add_to_lenght(2)
		area.get_parent().queue_free()
	pass # Replace with function body.
