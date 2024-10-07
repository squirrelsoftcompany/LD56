extends Node2D

@export var ground_level : float = 0
@export var detection_depth : float = 350
@export var detection_time : float = 6
@export var attack_depth : float = 200
@export var attack_chargeup : float = 3
@export var beak_anim : Curve = Curve.new()

var timer : float = 0
var aiming_timer : float = 0
var target : Vector2
var status : int = 0
var tremor : PackedScene = preload("res://assets/VFX/Tremor.tscn")
var impact : bool = false
var beak_sound : AudioStreamPlaybackPolyphonic
var foot_sound : AudioStreamPlaybackPolyphonic

var sfx : Array[AudioStreamWAV]=[
	preload("res://assets/audio/sfx/Beak-In.wav"),
	preload("res://assets/audio/sfx/Beak-Out.wav"),
	preload("res://assets/audio/sfx/Crow-Wing.wav"),
	preload("res://assets/audio/sfx/Step.wav"),
	preload("res://assets/audio/sfx/Crow-A.wav"),
	preload("res://assets/audio/sfx/Crow-B.wav")
]

enum {BEAK,SCRAPE,WING,STEP,CROW_A,CROW_B}
enum {FLIGHT,LANDING,IDLE,ATTACK,TAKE_OFF,MOVING}

@onready var worm : Node2D = MapGenerator.worm
@onready var feets : Array[Polygon2D] = [$Foot,$Foot2]
@onready var beak : Polygon2D = $Beak

func _ready():
	MapGenerator.birds.push_back(self)
	
func _process(delta):
	if status == FLIGHT:
		if worm.global_position.y < detection_depth+ground_level:
			timer += delta
			if timer > detection_time:
				target = worm.global_position
				land()
				
		elif timer > 0:
			timer -= delta*0.75
	elif status == LANDING:
		timer += delta
		land()
	elif status == IDLE:
		if worm.global_position.x-global_position.x >0:
			feets[0].scale.x = 1
			feets[1].scale.x = 1
			beak.scale.x = 1
		else:
			feets[0].scale.x = -1
			feets[1].scale.x = -1
			beak.scale.x = -1
		if worm.global_position.distance_to(global_position) > 600:
			move()
			aiming_timer = 0
			target = Vector2((worm.global_position.x),0)
		if worm.global_position.y < attack_depth+ground_level:
			aiming_timer += delta
			if aiming_timer > attack_chargeup:
				target = worm.global_position
				attack()
				timer = 0
		elif aiming_timer > 0:
			aiming_timer -= delta*2
		if worm.global_position.y > detection_depth+ground_level:
			if timer < detection_time:
				timer += delta
			else:
				take_off()
				aiming_timer = 0
		elif timer > 0:
			timer -= delta*0.75
	elif status == MOVING :
		move()
		aiming_timer += delta
	elif status == ATTACK :
		aiming_timer += delta
		attack()
	elif status == TAKE_OFF:
		timer += delta
		take_off()

func attack():
	if status == IDLE:
		status = ATTACK
		beak.visible = true
		beak.global_position.x = target.x
		beak.position.y = -400
		beak.get_child(1).monitorable = true
		var bam : Node2D = tremor.instantiate()
		bam.warning_length = 0.5
		bam.size = 500
		bam.max_alpha = 0.5
		feets[0].add_child(bam)
		bam = bam.duplicate()
		feets[1].add_child(bam)
		if not $Beak/AudioStreamPlayer2DBeak.playing :
			$Beak/AudioStreamPlayer2DBeak.play()
		beak_sound = $Beak/AudioStreamPlayer2DBeak.get_stream_playback()
		beak_sound.play_stream(sfx[CROW_A])
	if (not impact) and beak.position.y > 0:
		var bam : Node2D = tremor.instantiate()
		bam.warning_length = 0.5
		bam.size = 800
		bam.position = beak.position
		add_child(bam)
		impact = true
		if not $Beak/AudioStreamPlayer2DBeak.playing :
			$Beak/AudioStreamPlayer2DBeak.play()
		beak_sound = $Beak/AudioStreamPlayer2DBeak.get_stream_playback()
		beak_sound.play_stream(sfx[BEAK])
		beak_sound.play_stream(sfx[STEP])
	var prog = (aiming_timer-(attack_chargeup)) / 1.5
	beak.position.y = -400 +(550*beak_anim.sample(prog))
	if aiming_timer > attack_chargeup + 1.5:
		aiming_timer = 0
		status = IDLE
		beak.visible = false
		impact = false
		beak.get_child(1).monitorable = false

func land():
	if status == FLIGHT:
		status = LANDING
		feets[0].visible = true
		feets[1].visible = true
		global_position = Vector2(target.x,ground_level)
		feets[0].position = Vector2(-75,-500)
		feets[1].position = Vector2(75,-500)
		if not $AudioStreamPlayer2D.playing :
			$AudioStreamPlayer2D.play()
		foot_sound = $AudioStreamPlayer2D.get_stream_playback()
		foot_sound.play_stream(sfx[CROW_B])
		foot_sound.play_stream(sfx[WING])
	var prog = (timer -detection_time) /2
	feets[0].position = Vector2(-50,-500+500*prog)
	feets[1].position = Vector2(50,-500+500*prog)
	if timer > detection_time + 2:
		timer = 0
		status = IDLE
		var bam : Node2D = tremor.instantiate()
		bam.warning_length = 1
		bam.size = 500
		bam.max_alpha = 0.5
		feets[0].add_child(bam)
		bam = bam.duplicate()
		feets[1].add_child(bam)
		if not $AudioStreamPlayer2D.playing :
			$AudioStreamPlayer2D.play()
		foot_sound = $AudioStreamPlayer2D.get_stream_playback()
		foot_sound.play_stream(sfx[STEP])
		foot_sound.play_stream(sfx[SCRAPE])

func take_off():
	if status == IDLE:
		status = TAKE_OFF
		if not $AudioStreamPlayer2D.playing :
			$AudioStreamPlayer2D.play()
		foot_sound = $AudioStreamPlayer2D.get_stream_playback()
		foot_sound.play_stream(sfx[CROW_B])
		foot_sound.play_stream(sfx[WING])
		foot_sound.play_stream(sfx[WING],0.1)
		foot_sound.play_stream(sfx[STEP])
	var prog = (timer -detection_time) /2
	feets[0].position = Vector2(-50,-500*prog)
	feets[1].position = Vector2(50,-500*prog)
	if timer > detection_time + 2:
		timer = 0
		status = FLIGHT
		feets[0].visible = false
		feets[1].visible = false

func move():
	if status == IDLE:
		status = MOVING
		global_position.x = target.x
		if not $AudioStreamPlayer2D.playing :
			$AudioStreamPlayer2D.play()
		foot_sound = $AudioStreamPlayer2D.get_stream_playback()
		foot_sound.play_stream(sfx[STEP])
	global_position.y = ground_level -60 + 60*aiming_timer
	if aiming_timer >= 1:
		aiming_timer =0
		status = IDLE
		global_position.y = ground_level
		var bam : Node2D = tremor.instantiate()
		bam.warning_length = 0.8
		bam.size = 500
		bam.max_alpha = 0.5
		feets[0].add_child(bam)
		bam = bam.duplicate()
		feets[1].add_child(bam)
		if not $AudioStreamPlayer2D.playing :
			$AudioStreamPlayer2D.play()
		foot_sound = $AudioStreamPlayer2D.get_stream_playback()
		foot_sound.play_stream(sfx[STEP])
