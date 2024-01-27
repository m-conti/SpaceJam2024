class_name PowerLife
extends Power


@export var life: int = 1


func _activate():
    for zombie in get_tree().get_nodes_in_group("zombie"):
        zombie.max_life += life

