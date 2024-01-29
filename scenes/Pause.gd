extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event):
	if not event.is_action_released("pause"): return
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
