extends SubViewport


@export var tex_name := "test"


@onready var _top_cam2d : Camera2D = get_parent().get_viewport().get_camera_2d()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var test := 0
var timer := 5.0
func _process(delta: float) -> void:
	# sync sub camera and top camera
	var _sub_cam2d : Camera2D = get_camera_2d()
	assert(_sub_cam2d != _top_cam2d)
	_sub_cam2d.position = _top_cam2d.position
	_sub_cam2d.zoom = _top_cam2d.zoom
	
	#world_2d = get_parent().get_viewport().world_2d #debug
	
	$FOV_Mask._curve = get_tree().get_first_node_in_group("WormBody").worm._curve
	
	#if test < 10: # 10 screenshots
		#timer += delta
		#if timer > 5: # 5 seconds
			#test += 1
			#timer = 0
			#await RenderingServer.frame_post_draw
			#get_texture().get_image().save_png("res://Sprites/Mask/" + tex_name + "_" + str(test) + ".png")
			#print("Saved ", tex_name, " #", str(test))
