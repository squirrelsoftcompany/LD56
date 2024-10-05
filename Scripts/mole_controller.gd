extends CharacterBody2D


@export var max_rotation_speed_in_degrees := 40 # deg/s
@export var max_forward_speed := 80 # unit/s

@export var worm_max_distance := 1200
@export var worm_attack_distance := 150
@export var next_target_distance := 30
@export var random_position_radius := 500
@export var time_out := 15

var _worm_head : Node2D
var _current_target_position : Vector2
var _timer := 0.0

enum MoleState  {
	NEXT_RANDOM_TARGET,
	FOLLOW_RANDOM,
	GET_CLOSER,
	TARGETING,
	ATTACK,
}
var state := MoleState.NEXT_RANDOM_TARGET


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_worm_head = get_tree().get_first_node_in_group("WormHead")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# choose target
	var worm_position := _worm_head.position
	var worm_distance := worm_position.distance_to(global_position)
	var current_target_distance := _current_target_position.distance_to(global_position)
	DebugDraw2D.circle(worm_position, worm_max_distance, 16, Color(1, 0, 0), 1, delta)
	DebugDraw2D.circle(worm_position, worm_attack_distance, 16, Color(0, 0, 1), 1, delta)
	DebugDraw2D.circle(global_position, random_position_radius, 16, Color(0, 1, 0), 1, delta)
	var debug_color := Color()
	match(state):
		MoleState.NEXT_RANDOM_TARGET:
			var random_rotation := deg_to_rad(randf_range(0, 360))
			var direction := Vector2(cos(random_rotation), sin(random_rotation))
			_current_target_position = global_position + (direction * random_position_radius)
			_timer = 0
			debug_color = Color(0, 1, 0)
			# next state ?
			state = MoleState.FOLLOW_RANDOM
		MoleState.FOLLOW_RANDOM:
			_timer += delta
			debug_color = Color(0, 1, 0)
			# next state ?
			if worm_distance > worm_max_distance:
				state = MoleState.GET_CLOSER
			elif worm_distance < worm_attack_distance:
				state = MoleState.TARGETING
			elif current_target_distance < next_target_distance or _timer > time_out:
				state = MoleState.NEXT_RANDOM_TARGET
		MoleState.GET_CLOSER:
			_current_target_position = worm_position
			debug_color = Color(1, 0, 0)
			# next state ?
			if worm_distance < worm_max_distance:
				state = MoleState.NEXT_RANDOM_TARGET
		MoleState.TARGETING:
			_timer = 0
			_current_target_position = worm_position
			debug_color = Color(0, 0, 1)
			# next state ?
			if worm_distance > worm_max_distance:
				state = MoleState.GET_CLOSER
			elif current_target_distance < next_target_distance or _timer > time_out:
				state = MoleState.NEXT_RANDOM_TARGET
			else:
				state = MoleState.ATTACK
		MoleState.ATTACK:
			_timer += delta
			debug_color = Color(0, 0, 1)
			# next state ?
			if worm_distance > worm_max_distance:
				state = MoleState.GET_CLOSER
			elif _timer > time_out:
				state = MoleState.NEXT_RANDOM_TARGET
	DebugDraw2D.cube(_current_target_position, 10, debug_color, 1, delta)
	DebugDraw2D.circle(_current_target_position, next_target_distance, 16, debug_color, 1, delta)
	# compute rotation
	var target_direction := (_current_target_position - global_position).normalized()
	var rotation_scale := WormController._compute_rotation(target_direction, rotation)
	rotation += delta * rotation_scale * deg_to_rad(max_rotation_speed_in_degrees)
	# compute velocity
	var forward := WormController._get_forward_from_rotation(rotation)
	velocity = forward * max_forward_speed
	move_and_slide()
