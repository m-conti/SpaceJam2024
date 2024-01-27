class_name PowerMaxLimitZombies
extends Power

static var max_count: int = 4
static var current_count: int = 0

@export var augment_limit: int = 1


static func get_description() -> String:
    return "Increases the maximum number of zombies you can have by 1."

static func get_display_name() -> String:
	return "Max Limit Zombies"

func _activate():
    PowerMaxLimitZombies.current_count += 1
    Game.maxZombie += augment_limit
    queue_free()
