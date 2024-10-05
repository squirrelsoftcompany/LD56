class_name WormController
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
	var mouse_direction := (mouse_position - position).normalized()
	var rotation_scale := _compute_rotation(mouse_direction, rotation)
	rotation += delta * rotation_scale * deg_to_rad(max_rotation_speed_in_degrees)
	# compute velocity
	var forward := _get_forward_from_rotation(rotation)
	velocity = forward * max_forward_speed
	move_and_slide()


static func _compute_rotation(target_direction : Vector2, initial_rotation: float) -> float:
	var forward := _get_forward_from_rotation(initial_rotation)
	var cosinus := forward.dot(target_direction)
	var sinus := forward.cross(target_direction)
	var rotation_scale : float = sinus if cosinus >= 0.0 else sign(sinus)
	return rotation_scale


static func _get_forward_from_rotation(rot : float) -> Vector2:
	return Vector2(cos(rot), sin(rot))
