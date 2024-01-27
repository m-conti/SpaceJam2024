class_name Power
extends Node


static var description: String:
    get: return get_description()


static func get_description() -> String:
    return ""

static func get_display_name() -> String:
    return ""

func _activate_on_zombie(_zombie: Zombie):
    pass


func _activate():
    get_tree().get_nodes_in_group("zombie").map(_activate_on_zombie)
    Game.player.spawn_zombie.connect(_activate_on_zombie)