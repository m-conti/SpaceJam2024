class_name PowerStamina
extends Power

static var max_count: int = 4
static var current_count: int = 0

@export var stamina_factor: float = 1.5


static func get_description() -> String:
	return "Increases the stamina of your zombies by 50%."

static func get_display_name() -> String:
	return "Stamina"

func _activate():
	PowerStamina.current_count += 1
	super._activate()


func _activate_on_zombie(zombie: Zombie):
	zombie.max_stamina *= stamina_factor
