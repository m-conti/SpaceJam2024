class_name PowerStamina
extends Power


@export var stamina_factor: float = 1.5


static func get_description() -> String:
    return "Increases the stamina of your zombies by 50%."


func _activate_on_zombie(zombie: Zombie):
    zombie.stamina *= stamina_factor
