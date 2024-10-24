extends Node2D

var last_pos : Vector2
var gallery : LinePath2D

@export var width : float =50 :
	set(value):
		width = value
		if is_instance_valid(gallery):
			gallery.width = value *1.1

@export var color := Color(0,0,0)

func _ready():
	gallery = $GalleryPath
	last_pos = global_position
	gallery._curve = Curve2D.new() # do not remove the underscore !!
	gallery.curve.add_point(last_pos)
	gallery.curve.add_point(last_pos)
	gallery.cap_end_cap = 2
	gallery.cap_begin_cap = 2
	gallery.width = width*1.1
	gallery.fill_default_color = color
	remove_child(gallery)
	get_tree().get_nodes_in_group("PathsOrigin")[0].add_child(gallery)

func _process(_delta):
	var dist : float = (global_position - last_pos).length()
	if dist > width * 5:
		gallery._curve = Curve2D.new()
	if dist > width/2:
		gallery.curve.add_point(global_position)
		last_pos = global_position
		if gallery.curve.point_count > 32:
			gallery.curve.remove_point(0)
	else:
		gallery.curve.set_point_position(gallery.curve.point_count-1,global_position)
						#----- move test -----
	#position += Vector2(1,randf_range(-0.5,1.2))
