class_name Food
extends Sprite2D

@export var indicator : Node2D

@export var max_scale : float
@export var min_scale : float
@export var grow_up_distance : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	indicator.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func show_indicator(indicator_global_position : Vector2):
	indicator.global_position = indicator_global_position
	indicator.look_at(global_position)
	#indicator.scale.x
	
	# Change scale if near
	var _distance = (indicator_global_position - global_position).length() 
	if _distance < grow_up_distance:
		indicator.scale.x = (min_scale + (max_scale-min_scale)*(1-_distance/grow_up_distance))
		indicator.scale.y = (min_scale + (max_scale-min_scale)*(1-_distance/grow_up_distance))
	else:
		indicator.scale.x = min_scale
		indicator.scale.y = min_scale
		
	indicator.visible = true
	
	
func hide_indicator():
	indicator.visible = false
