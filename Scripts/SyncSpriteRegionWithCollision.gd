extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StaticBody2D/CollisionShape2D.scale = region_rect.size
