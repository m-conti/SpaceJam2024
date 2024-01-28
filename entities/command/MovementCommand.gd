extends Node2D

@onready var lifeTimer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var node = get_tree().get_first_node_in_group("command")
	if is_instance_valid(node):
		node.queue_free()
	add_to_group("command")
	var zombies = get_tree().get_nodes_in_group("zombie")
	for zombie in zombies:
		(zombie as Zombie).command(self)
	
	lifeTimer.autostart = true
	lifeTimer.one_shot = true
	lifeTimer.wait_time = 6.0
	lifeTimer.timeout.connect(death)
	add_child(lifeTimer)

func death():
	queue_free()
