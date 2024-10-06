extends Polygon2D

@export var min_cluster : int = 3
@export var max_cluster : int = 5
@export var max_range : float = 250

var clusters : Array[Polygon2D]
var _nb_cluster : int =0

func _ready():
	var gallery : LinePath2D = get_child(1)
	gallery._curve = Curve2D.new()
	gallery.curve.add_point(Vector2.ZERO)
	clusters.append(get_child(0))
	_nb_cluster = randi_range(min_cluster,max_cluster)
	print(_nb_cluster)
	var last_angle : float = 0
	for i in _nb_cluster:
		if i > 0 :
			clusters.append(clusters[0].duplicate())
			add_child(clusters[i])
			gallery = gallery.duplicate()
			add_child(gallery)
			gallery._curve = Curve2D.new()
			gallery.curve.add_point(Vector2.ZERO)
		var _dist : float = randf_range(75,max_range)
		var _reserved_arc : float = ((TAU-last_angle)/(_nb_cluster-i))
		var _angle : float = randf_range(last_angle+(_reserved_arc/3),_reserved_arc+last_angle)
		last_angle = _angle
		clusters[i].position = _dist*Vector2(cos(_angle),sin(_angle))
		gallery.curve.add_point(clusters[i].position)
		gallery.curve.set_point_out(0,(_dist/3)*Vector2(cos(_angle),sin(_angle))+Vector2(randf_range(-50,50),randf_range(-50,50)))
		clusters[i].polygon = generate_poly(randi_range(5,8))
		clusters[i].get_child(2).get_child(0).polygon = clusters[i].polygon

func generate_poly(points : int = 6, size : float = 20) -> PackedVector2Array:
	var poly : PackedVector2Array
	var last_angle : float = 0.01
	for i in points:
		var _dist : float = randf_range(size/2,size)
		var _reserved_arc : float = ((TAU-last_angle)/(points-i))
		var _angle : float = randf_range(last_angle+(_reserved_arc/3)+ 0.01,_reserved_arc+last_angle)
		last_angle = _angle
		poly.append(_dist*Vector2(cos(_angle),sin(_angle)))
	return poly
