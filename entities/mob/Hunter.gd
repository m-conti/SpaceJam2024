class_name Hunter
extends Human


@export var attack_range: float = 100.0


func change_target_mode():
	if target == null:
		return

	var distance = target_pos.distance_to(position)
	
	if distance > attack_range:
		targetMode = ETargetMode.ATTACK
	else:
		targetMode = ETargetMode.FLEE
