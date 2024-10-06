extends Node2D


@onready var _top_cam2d : Camera2D = get_viewport().get_camera_2d()
@onready var _fov : MeshInstance2D = $FOV


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(_fov.material as ShaderMaterial).set_shader_parameter("FOV_Mask", $"../FOV_Mask_VP".get_texture())
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_fov.position = _top_cam2d.position
