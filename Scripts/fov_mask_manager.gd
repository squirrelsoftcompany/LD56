extends SubViewport


@export var tex_name := "test"


@onready var _viewport : Viewport = get_parent().get_viewport()
@onready var _top_cam2d : Camera2D = _viewport.get_camera_2d()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# sync sub camera and top camera
	var _sub_cam2d : Camera2D = get_camera_2d()
	assert(_sub_cam2d != _top_cam2d)
	_sub_cam2d.position = _top_cam2d.position
	_sub_cam2d.zoom = _top_cam2d.zoom
	size = _viewport.get_visible_rect().size
	
	$FOV_Mask._curve = get_tree().get_first_node_in_group("WormBody").worm._curve
