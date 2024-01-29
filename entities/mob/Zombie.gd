extends Mob
class_name Zombie

@onready var player = get_parent().get_node("%Player")


static func get_entity_group():
	return "zombie"


func _ready():
	super._ready()
	(%Vision as Area2D).body_entered.connect(seeSomething)
	(%AttackArea).body_entered.connect(attack)
	(%AttackArea).area_entered.connect(reachCommand)

func toggleRun(value: bool) -> bool:
	if not super.toggleRun(value): return false
	set_collision_layer_value(5, value)
	return true


func _process(delta):
	super._process(delta)
	if target != null and target.is_in_group("human"):
		targetMode = ETargetMode.ATTACK
		toggleRun(true)

func seeSomething(body):
	if not body is Entity:
		return
	#if target and target.is_in_group("command"):
		#return
	if target == null or not target.is_in_group("human"):
		target = body
	elif body.position.distance_to(position) < target_pos.distance_to(position):
		target = body


func _on_death():
	super._on_death()
	Game.addXp(1)
	Game.zombie_count_changed.emit(Game.zombieNumber)

func attack(body):
	if body.is_in_group("human"):
		body.attacked.emit()
		attack_particle.play("attack")

func reachCommand(area):
	if target == null: return
	if area.get_parent().is_in_group("command") and target.is_in_group("command"):
		target = null

func command(body: Node2D):
	targetMode = ETargetMode.COMMAND
	target = body
