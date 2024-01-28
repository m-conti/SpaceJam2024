extends Node2D

@onready var lifeTimer = Timer.new()

var isFocused: bool = false

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

func action():
	(%Animation as AnimatedSprite2D).animation = "active"
	var zombies = get_tree().get_nodes_in_group("zombie")
	for zombie in zombies:
		zombie.toggleRun(true)
	pass

func _on_area_2d_mouse_entered():
	isFocused = true
	pass # Replace with function body.

func _on_area_2d_mouse_exited():
	isFocused = false
	pass # Replace with function body.
