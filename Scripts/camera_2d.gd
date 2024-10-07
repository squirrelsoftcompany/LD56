extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = get_tree().get_first_node_in_group("WormHead").position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_tree().get_first_node_in_group("WormHead").position
