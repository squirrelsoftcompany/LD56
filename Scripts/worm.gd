extends Node2D

var worm : Path2D
var gallery : Path2D
var width : float :
	set(value):
		worm.width = value
		gallery.width = value
		width = value
var _invincibility : float = 0.1 #for safe spawning purposes
var _damaged : float = 0
var _valid_hit : bool = false # for simultateous hits

@export var start_width : float = 50
@export var length : float = 300
@export var invincibility_time : float = 1
@export var healing_time : float = 1

@onready var nerves : Array[Area2D] = [$Skin/Nerve]

func _ready():
	worm = $WormPath
	gallery = $Gallery.gallery
	worm._curve = gallery.curve.duplicate() # do not remove the underscore !!
	worm.cap_end_cap = 2
	worm.cap_begin_cap = 2
	width = start_width
	worm.width = width
	gallery.width = width
	remove_child(worm)
	get_tree().get_nodes_in_group("PathsOrigin")[0].add_child(worm)
	gallery.z_index = -4
	MapGenerator.worm = self

func _process(delta):
	if _valid_hit:
		_invincibility = invincibility_time
		_valid_hit=false
		if _damaged <= 0:
			_damaged = healing_time
			print("aïe!")
		else :
			print("dead")
	if _invincibility > 0:
		_invincibility -= delta
	if _damaged > 0:
		_damaged -= delta
	if gallery.curve.point_count > 2:
		worm._curve = gallery.curve.duplicate()
		var butt_progress : float = gallery.curve.get_baked_length()-length
		var butt_pos : Vector2 = gallery.curve.sample_baked(butt_progress)
		$Butt.global_position = butt_pos
		if gallery.curve.get_baked_length() > length:
			while worm.curve.get_baked_length() > length:
				worm.curve.remove_point(0)
			worm.curve.add_point(butt_pos,Vector2.ZERO,Vector2.ZERO,0)
	update_nerves()
						#----- move test -----
	#position += Vector2(1,randf_range(-0.5,1.2))

func update_nerves() :
	var segments : int = worm.curve.point_count -1
	for i in segments:
		var pos : Vector2 = (worm.curve.get_point_position(i)+worm.curve.get_point_position(i+1))/2
		var length : float = (worm.curve.get_point_position(i+1)-worm.curve.get_point_position(i)).length()+ width
		var angle : float = (worm.curve.get_point_position(i+1)-worm.curve.get_point_position(i)).angle()+PI/2
		if i == nerves.size():
			nerves.append(nerves[0].duplicate())
			nerves[i].get_child(0).shape = CapsuleShape2D.new()
			nerves[0].add_sibling(nerves[i])
		nerves[i].get_child(0).shape.height = length
		nerves[i].global_position = pos
		nerves[i].get_child(0).shape.radius = width/2
		nerves[i].global_rotation = angle
	if nerves.size() >= segments:
		for i in nerves.size() - segments:
			var surplus_nerve : Area2D = nerves[segments]
			nerves.remove_at(segments)
			surplus_nerve.queue_free()

func add_to_lenght(increment : float):
	length = length + increment
	pass

func _on_contact(culprit : Node2D):
	if culprit.is_in_group("Damager") and _invincibility <= 0:
		_valid_hit = true
