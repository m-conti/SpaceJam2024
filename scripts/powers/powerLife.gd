class_name PowerLife
extends Power


@export var life: int = 1


func _activate_on_zombie(zombie: Zombie):
    zombie.max_life += life

