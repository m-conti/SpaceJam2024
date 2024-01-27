extends Mob
class_name Zombie

@onready var player = get_parent().get_node("%Player")


func _ready():
	(%Vision as Area2D).body_entered.connect(seeSomething)
	(%AttackArea).body_entered.connect(attack)


func toggleRun(value: bool) -> bool:
	if not super.toggleRun(value): return false
	set_collision_layer_value(5, value)
	return true


func _process(delta):
	super._process(delta)
	if target == null:
		target = player
	if target != player:
		toggleRun(true)

func seeSomething(body):
	if target == null or target == player:
		target = body
	elif body.position.distance_to(position) < target.position.distance_to(position):
		target = body


func attack(body):
	print("attack", body)
	body.attacked.emit()
