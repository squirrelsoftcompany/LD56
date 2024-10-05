extends Node2D

var last_pos : Vector2
var gallery : Path2D 

@export var width : float =50 :
	set(value):
		width = value
		gallery.width = value *1.1

func _ready():
	gallery = $GalleryPath
	last_pos = global_position
	gallery._curve = Curve2D.new() # do not remove the underscore !!
	gallery.curve.add_point(last_pos)
	gallery.curve.add_point(last_pos)
	gallery.cap_end_cap = 2
	gallery.cap_begin_cap = 2
	gallery.width = width*1.1

func _process(_delta):
	if (global_position - last_pos).length() > width:
		gallery.curve.add_point(global_position)
		last_pos = global_position
	else:
		gallery.curve.set_point_position(gallery.curve.point_count-1,global_position)
						#----- move test -----
	#position += Vector2(1,randf_range(-0.5,1.2))
