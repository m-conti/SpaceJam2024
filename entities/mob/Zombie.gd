extends Mob
class_name Zombie

@onready var player = get_parent().get_node("%Player")


func _ready():
	super._ready()
	(%Vision as Area2D).body_entered.connect(seeSomething)
	(%AttackArea).body_entered.connect(attack)


func toggleRun(value: bool) -> bool:
	if not super.toggleRun(value): return false
	set_collision_layer_value(5, value)
	return true


func _process(delta):
	super._process(delta)
	if target != null and target != player:
		targetMode = ETargetMode.ATTACK
		toggleRun(true)

func seeSomething(body):
	if target == null or target == player:
		target = body
	elif body.position.distance_to(position) < target_pos.distance_to(position):
		target = body


func _on_death():
	super._on_death()
	Game.addXp(1)
	Game.zombie_count_changed.emit(Game.zombieNumber)

func attack(body):
	body.attacked.emit()
