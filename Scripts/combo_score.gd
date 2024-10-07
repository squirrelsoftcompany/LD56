extends RichTextLabel


@export var placeholder_string := "PLACEHOLDER"
@export var scoring_time : float = 1


@onready var _format := text


var last_tween : Tween
var current_score : int = 0
var score := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_score = MapGenerator.worm.length
	MapGenerator.worm_scored.connect(new_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	format_score(current_score)

func new_score(_score : int):
	score = _score
	if last_tween:
		last_tween.stop()
	var delta := score - current_score
	var timeframe := scoring_time/delta
	if delta > 0:
		last_tween = create_tween()
		for i in delta:
			last_tween.tween_property(self, "current_score", current_score+i+1, 0.0)
			last_tween.tween_property(self, "rotation_degrees", -5 if i % 5 == 0 else 5, timeframe/2)
			last_tween.tween_property(self, "rotation_degrees", 0, timeframe/2)


func format_score(_score : int):
	text = _format.replace(placeholder_string, "%010d" % _score)
