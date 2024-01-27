class_name Player
extends Entity


@export var walkSpeed: float = 6000.0
@export var runSpeed: float = 16000.0
@export var stamina: float = 10.0
var isRunning: bool = false
@export var attack_speed: float = 0.5:
	set(value): attackTimer.wait_time = 1 / value

var score: int = 0:
	set(value):
		value = 0 if value < 0 else value

		if score == value: return

		score = value
		score_changed.emit(value)

@onready var attackTimer: Timer = Timer.new()

var last_chunck

var speed: float:
	get: return runSpeed if isRunning else walkSpeed

signal score_changed(value: int)
signal spawn_zombie(zombie: Zombie)


func _ready():
	super._ready()
	Game.player = self
	self.add_child(attackTimer)
	attackTimer.wait_time = 1 / attack_speed
	attackTimer.one_shot = true

	generate_chuncks()


func _input(event):
	if event.is_action_pressed("run"):
		self.toggleRun(true)
	if event.is_action_released("run"):
		self.toggleRun(false)
	if event.is_action_pressed("attack"):
		askToAttack()


func _on_death():
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")


func toggleRun(value: bool):
	isRunning = value
	set_collision_layer_value(5, value)


func generate_chuncks():
	var map: Map = Game.map

	var chunck: Vector2i = map.local_to_map(map.to_local(global_position)) / map.background_generator.chunck_size

	if chunck == last_chunck: return
	last_chunck = chunck

	map.generate_chunck_around(chunck)


func _physics_process(delta):
	super._physics_process(delta)

	generate_chuncks()

	var direction = Vector2()
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	velocity = direction.normalized() * speed * delta
	move_and_slide()


func attack():
	var bodies = (%AttackArea as Area2D).get_overlapping_bodies()
	if bodies.size() == 0: return
	var to_kill = bodies[0]
	to_kill.attacked.emit()


func askToAttack():
	if attackTimer.is_stopped():
		attackTimer.timeout.disconnect(askToAttack)
		attackTimer.start(attack_speed)
		attack()
	elif not attackTimer.timeout.is_connected(askToAttack):
		attackTimer.timeout.connect(askToAttack)
