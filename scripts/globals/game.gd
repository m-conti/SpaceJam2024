extends Node

var lvlUpScene: PackedScene = preload("res://UI/powerSelection/PowerSelection.tscn")

var player: Player
var map: Map

var maxZombie: int = 5
var zombieNumber: int:
	get: return get_tree().get_nodes_in_group("zombie").size()

var lvl: int = 0

var current_xp: float = 0
@onready var xp_needed: float = get_xp_needed_by_lvl()


signal zombie_count_changed(count: int)
signal xp_changed
signal lvl_changed

const curve_xp_height = 10
const curve_xp_width = 0.4

func addXp(value: float):
	current_xp += value
	if current_xp >= xp_needed:
		current_xp = 0
		_on_level_up()
	xp_changed.emit()

func get_xp_needed_by_lvl() -> float:
	return curve_xp_height * exp(curve_xp_width * lvl)


func getPower(n_powers: int) -> Array:
	var powers_file := Array(DirAccess.get_files_at("res://scripts/powers"))
	if powers_file.size() <= 0:
		return []

	var powers: Array = []

	for i in range(n_powers):
		var power_file: String = powers_file.pick_random()
		var power = load("res://scripts/powers/" + power_file)

		while power.current_count >= power.max_count:
			power_file = powers_file.pick_random()
			power = load("res://scripts/powers/" + power_file)
		
		powers_file.erase(power_file)
		powers.append(power)

		if powers_file.size() <= 0:
			return powers
	
	return powers

func _on_level_up():
	lvl += 1
	xp_needed = get_xp_needed_by_lvl()
	lvl_changed.emit()
	get_tree().paused = true
	var scene = lvlUpScene.instantiate()
	get_tree().root.add_child(scene)
