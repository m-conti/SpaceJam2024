class_name Player
extends Entity

var FlagCommand: PackedScene = preload("res://entities/command/MovementCommand.tscn")

@export var attack_speed: float = 0.5:
	set(value):
		if attackTimer == null:
			return
		attackTimer.wait_time = 1 / value

var score: int = 0:
	set(value):
		value = 0 if value < 0 else value

		if score == value: return

		score = value
		score_changed.emit(value)

@onready var attackTimer: Timer = Timer.new()
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var last_chunck
@onready var sprite: AnimatedSprite2D = %Sprite

signal score_changed(value: int)
signal spawn_zombie(zombie: Zombie)


func _ready():
	super._ready()
	Game.player = self
	self.add_child(attackTimer)

	var x: int = 0
	while not Game.map.can_move(Vector2i(x, 0)):
		x += 1
	
	print(Vector2i(x, 0))

	global_position = Game.map.to_global(Game.map.map_to_local(Vector2i(x, 0)))

	attackTimer.wait_time = 1 / attack_speed
	attackTimer.one_shot = true
	hit.connect(func(): animation_player.play("Hit"))
	score_changed.connect(_on_change_score)
	generate_chuncks()

func _on_change_score(score):
	print("CHANGE PITCH", 1 + score / 100)
	(get_parent().get_node("Music") as AudioStreamPlayer).pitch_scale = 1 + float(score) / 5000

func _input(event):
	if event.is_action_pressed("run"):
		self.toggleRun(true)
	if event.is_action_released("run"):
		self.toggleRun(false)
	if event.is_action_pressed("attack"):
		askToAttack()
	if event.is_action_pressed("command"):
		onCommand(event)


func _on_death():
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")


func toggleRun(value: bool) -> bool:
	if not super.toggleRun(value):
		return false
	set_collision_layer_value(5, value)
	return true


func generate_chuncks():
	var map: Map = Game.map

	var chunck: Vector2i = map.local_to_map(map.to_local(global_position)) / map.background_generator.chunck_size

	if chunck == last_chunck: return
	last_chunck = chunck

	map.generate_chunck_around(chunck)




func _physics_process(delta):
	super._physics_process(delta)

	generate_chuncks()

	velocity = get_direction().normalized() * speed * delta
	move_and_slide()


func get_direction():
	var direction = Vector2()
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	if direction.y < 0:
		sprite.play("WalkUp")
	elif direction.y > 0:
		sprite.play("WalkDown")
	elif direction.x < 0:
		sprite.play("WalkLeft")
	elif direction.x > 0:
		sprite.play("WalkRight")
	else:
		sprite.stop()

	return direction


func attack():
	var bodies = (%AttackArea as Area2D).get_overlapping_bodies().filter(func(body): return body is Entity)
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

func onCommand(event: InputEventMouseButton):
	var oldCommand = get_tree().get_first_node_in_group("command")
	if oldCommand and (oldCommand.isFocused or event.double_click):
		oldCommand.action()
		return
	var command = FlagCommand.instantiate()
	command.position = get_global_mouse_position()
	get_parent().add_child(command)
	pass
