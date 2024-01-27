class_name Anim


static func animate(object, property: String, value, duration) -> void:
	var tween = object.create_tween()
	tween.tween_property(object, property, value, duration)
	await tween.finished
	tween.kill()
