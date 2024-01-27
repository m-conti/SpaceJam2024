extends Mob
class_name Zombie


# Called when the node enters the scene tree for the first time.
func _ready():
	(%Vision as Area2D).body_entered.connect(seeSomething)
	(%AttackArea).body_entered.connect(attack)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	if target == null:
		target = %Player

func seeSomething(body):
	if target == null or target == %Player:
		target = body
	elif body.position.distance_to(position) < target.position.distance_to(position):
		target = body

func attack(body):
	print("attack", body)
	body.attacked.emit()
