class_name FearHuman
extends Human


static func get_score():
	return 1


func change_target_mode():
	if target == null:
		return

	targetMode = ETargetMode.FLEE


func change_looking_direction():
	super.change_looking_direction()
	if target != null:
		vision.rotate(PI)
