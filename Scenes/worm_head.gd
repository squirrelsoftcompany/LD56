extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# compute rotation
	var mouse_position := get_global_mouse_position() # mouse position in world units
	var forward := Vector2(cos(rotation), sin(rotation))
	var mouse_direction := (mouse_position - position).normalized()
	var cosinus := forward.dot(mouse_direction)
	var sinus := forward.cross(mouse_direction)
	var rotation_scale : float = sinus if cosinus >= 0.0 else sign(sinus)
	var max_rotation_speed := deg_to_rad(40) # deg/s
	rotation += delta * rotation_scale * max_rotation_speed
	# compute velocity
	var max_forward_speed := 40 # unit/s
	velocity = forward * max_forward_speed
	move_and_slide()
