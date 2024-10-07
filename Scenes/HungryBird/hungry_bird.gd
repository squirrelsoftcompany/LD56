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

enum {FLIGHT,LANDING,IDLE,ATTACK,TAKE_OFF}

@onready var worm : Node2D = MapGenerator.worm
@onready var feets : Array[Polygon2D] = [$Foot,$Foot2]
@onready var beak : Polygon2D = $Beak

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
		move()
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
	if (not impact) and beak.position.y > 0:
		var bam : Node2D = tremor.instantiate()
		bam.warning_length = 0.8
		bam.size = 800
		bam.position = beak.position
		add_child(bam)
		impact = true
	var prog = (aiming_timer-(attack_chargeup)) / 1.5
	beak.position.y = -400 +(550*beak_anim.sample(prog))
	if aiming_timer > attack_chargeup + 1.5:
		aiming_timer = 0
		status = IDLE
		beak.visible = false
		impact = false

func land():
	if status == FLIGHT:
		status = LANDING
		feets[0].visible = true
		feets[1].visible = true
		global_position = Vector2(target.x,ground_level)
		feets[0].position = Vector2(-75,-500)
		feets[1].position = Vector2(75,-500)
	var prog = (timer -detection_time) /2
	feets[0].position = Vector2(-50,-500+500*prog)
	feets[1].position = Vector2(50,-500+500*prog)
	if timer > detection_time + 2:
		timer = 0
		status = IDLE
		var bam : Node2D = tremor.instantiate()
		bam.warning_length = 1
		bam.size = 500
		feets[0].add_child(bam)
		bam = bam.duplicate()
		feets[1].add_child(bam)

func take_off():
	if status == IDLE:
		status = TAKE_OFF
	var prog = (timer -detection_time) /2
	feets[0].position = Vector2(-50,-500*prog)
	feets[1].position = Vector2(50,-500*prog)
	if timer > detection_time + 2:
		timer = 0
		status = FLIGHT
		feets[0].visible = false
		feets[1].visible = false

func move():
	#TODO : move feets to follow worm
	pass
