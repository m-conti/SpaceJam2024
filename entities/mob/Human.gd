extends Mob
class_name Human


signal attacked

@export var zombie_scene: PackedScene
static var score: float:
	get = get_score

@onready var vision: Area2D = %Vision
@onready var hearing: Area2D = %Hearing


static func get_entity_group():
	return "human"


static func get_score() -> float:
	return 1.0


func _ready():
	super._ready()
	vision.body_entered.connect(seeSomething)
	hearing.body_entered.connect(hearSomathing)
	attacked.connect(_on_attacked)


func _process(delta):
	super._process(delta)

	change_run_type()
	change_target_mode()
	change_looking_direction()


func seeSomething(body: CharacterBody2D):
	setTarget(body)


func hearSomathing(body: CharacterBody2D):
	setTarget(body)


func setTarget(body: CharacterBody2D):
	if not target:
		target = body
	elif body.position.distance_to(position) < target_pos.distance_to(position):
		target = body


func change_looking_direction():
	if target or targetMode == ETargetMode.WANDER:
		vision.look_at(target_pos)
	if targetMode == ETargetMode.WANDER:
		vision.rotate(PI)


func change_target_mode():
	targetMode = ETargetMode.FLEE


func change_run_type():
	if target:
		toggleRun(true)


func die():
	self.queue_free()

	Game.player.score += score

	if Game.zombieNumber >= Game.maxZombie:
		Game.addXp(2)
		return
	var zombie: Node2D = zombie_scene.instantiate()
	get_parent().add_child(zombie)

	zombie.position = position
	zombie.global_scale = global_scale

	Game.player.spawn_zombie.emit(zombie)
	Game.zombie_count_changed.emit(Game.zombieNumber)

func _on_attacked():
	self.die()
