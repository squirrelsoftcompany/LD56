extends MeshInstance2D

#color can be changed in modulate, alpha will be overriden by this script

@export var continuous : bool = false
@export var size : int = 100
@export var warning_length : float = 2
@export var max_alpha : float = 1

var _time : float = 0

func _ready():
	scale = Vector2(size,size)

func _process(delta):
	if _time <= warning_length:
		modulate.a = _time/warning_length
	if not continuous :
		if _time > warning_length:
			modulate.a = 1-((_time-warning_length)/warning_length)
			if _time > 2*warning_length :
				queue_free()
	modulate.a = modulate.a if modulate.a < max_alpha else max_alpha
	if _time < 2* warning_length :
		_time += delta
