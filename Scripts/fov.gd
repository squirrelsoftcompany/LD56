extends Node2D


@onready var _top_cam2d : Camera2D = get_viewport().get_camera_2d()
@onready var _fov : MeshInstance2D = $FOV
@onready var _fov_mask = get_tree().get_first_node_in_group("FOVMask")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(_fov.material as ShaderMaterial).set_shader_parameter("FOV_Mask", _fov_mask.get_texture())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_fov.position = _top_cam2d.position
	_fov.scale.x = get_viewport_rect().size.x / _top_cam2d.zoom.x
	_fov.scale.y = -get_viewport_rect().size.y / _top_cam2d.zoom.y
