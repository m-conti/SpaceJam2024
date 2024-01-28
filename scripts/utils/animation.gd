class_name Anim


static func animate(object, property: String, value, duration) -> void:
	var tween = object.create_tween()
	tween.tween_property(object, property, value, duration)
	await tween.finished
	tween.kill()


static func animate_angle(object: Node, property: String, current_value: float, target_value: float, duration: float) -> void:
	var diff: float = target_value - current_value

	while diff > PI:
		diff -= TAU
	while diff < -PI:
		diff += TAU
	
	await animate(object, property, current_value + diff, duration)
