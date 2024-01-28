class_name Player
extends Entity

var FlagCommand: PackedScene = preload("res://entities/command/MovementCommand.tscn")

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
@onready var sprite: AnimatedSprite2D = %Sprite

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
	if event.is_action_pressed("command"):
		onCommand()


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

func onCommand():
	var oldCommand = get_tree().get_first_node_in_group("command")
	if oldCommand and oldCommand.isFocused:
		oldCommand.action()
		return
	var command = FlagCommand.instantiate()
	command.position = get_global_mouse_position()
	get_parent().add_child(command)
	pass
