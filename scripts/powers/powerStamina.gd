class_name PowerStamina
extends Power

static var max_count: float = 4
static var current_count: float = 0

@export var stamina_factor: float = 1.5


static func get_description() -> String:
    return "Increases the stamina of your zombies by 50%."


func _activate():
	PowerStamina.current_count += 1
	super._activate()


func _activate_on_zombie(zombie: Zombie):
    zombie.stamina *= stamina_factor
