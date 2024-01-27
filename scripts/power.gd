class_name Power
extends Node


func _activate_on_zombie(_zombie: Zombie):
    pass


func _activate():
    get_tree().get_nodes_in_group("zombie").map(_activate_on_zombie)
    Game.player.spawn_zombie.connect(_activate_on_zombie)