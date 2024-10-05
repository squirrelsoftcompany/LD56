extends Node2D

var worm : Path2D
var gallery : Path2D

@export var width : float =50 :
	set(value):
		width = value
		worm.width = value
@export var length : float = 300

func _ready():
	worm = $WormPath
	gallery = $Gallery.gallery
	worm._curve = gallery.curve.duplicate() # do not remove the underscore !!
	worm.cap_end_cap = 2
	worm.cap_begin_cap = 2
	worm.width = width

func _process(_delta):
	worm._curve = gallery.curve.duplicate()
	if gallery.curve.get_baked_length() > length:
		var butt_progress : float = gallery.curve.get_baked_length()-length
		while worm.curve.get_baked_length() > length:
			worm.curve.remove_point(0)
		worm.curve.add_point(gallery.curve.sample_baked(butt_progress),Vector2.ZERO,Vector2.ZERO,0)
						#----- move test -----
	#position += Vector2(1,randf_range(-0.5,1.2))
