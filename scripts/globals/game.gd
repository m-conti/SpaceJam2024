extends Node


var player: Player
var map: Map

var maxZombie: int = 5
var zombieNumber: int:
	get: return get_tree().get_nodes_in_group("zombie").size()

signal zombie_count_changed(count: int)
