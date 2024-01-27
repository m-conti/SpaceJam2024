class_name ZombieCount
extends Label

func _ready():
	Game.zombie_count_changed.connect(_on_zombie_count_changed)
	Game.zombie_count_changed.emit(Game.zombieNumber)
	print("INIT ", Game.zombieNumber)


func _on_zombie_count_changed(value):
	print("ZOMBIES", value)
	text = "Zombies : " + str(value)
