extends CharacterBody2D


@export var max_rotation_speed_in_degrees := 40 # deg/s
@export var max_forward_speed := 40 # unit/s


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
	rotation += delta * rotation_scale * deg_to_rad(max_rotation_speed_in_degrees)
	# compute velocity
	var neo_forward := Vector2(cos(rotation), sin(rotation))
	velocity = neo_forward * max_forward_speed
	move_and_slide()
