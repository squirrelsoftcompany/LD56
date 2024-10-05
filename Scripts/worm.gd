extends Node2D

var worm : Path2D
var gallery : Path2D
var width : float :
	set(value):
		worm.width = value
		gallery.width = value
		width = value

@export var start_width : float =50 
@export var length : float = 300

func _ready():
	worm = $WormPath
	gallery = $Gallery.gallery
	worm._curve = gallery.curve.duplicate() # do not remove the underscore !!
	worm.cap_end_cap = 2
	worm.cap_begin_cap = 2
	width = start_width
	worm.width = width
	gallery.width = width

func _process(_delta):
	worm._curve = gallery.curve.duplicate()
	if gallery.curve.get_baked_length() > length:
		var butt_progress : float = gallery.curve.get_baked_length()-length
		while worm.curve.get_baked_length() > length:
			worm.curve.remove_point(0)
		var butt_pos : Vector2 = gallery.curve.sample_baked(butt_progress)
		$WormPath/Butt.position = butt_pos
		worm.curve.add_point(butt_pos,Vector2.ZERO,Vector2.ZERO,0)
						#----- move test -----
	#position += Vector2(1,randf_range(-0.5,1.2))
