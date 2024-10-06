extends MeshInstance2D


@onready var _cam2d : Camera2D = get_viewport().get_camera_2d()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position = _cam2d.position
	rotation = _cam2d.rotation
