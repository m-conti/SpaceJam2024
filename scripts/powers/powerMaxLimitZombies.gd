class_name PowerMaxLimitZombies
extends Power


@export var augment_limit: int = 1


func _activate():
    Game.maxZombie += augment_limit
