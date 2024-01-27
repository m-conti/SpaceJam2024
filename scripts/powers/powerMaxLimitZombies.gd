class_name PowerMaxLimitZombies
extends Power


@export var augment_limit: int = 1


static func get_description() -> String:
    return "Increases the maximum number of zombies you can have by 1."


func _activate():
    Game.maxZombie += augment_limit
