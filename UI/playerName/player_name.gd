extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_parent().name_already_used.connect(name_already_used)
	pass # Replace with function body.


func name_already_used():
	(%AlreadyUsed as Label).modulate = Color(255, 255, 255, 255)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	var new_name = %Name.text
	if new_name != "":
		get_parent().name_choosed.emit(new_name)
	pass # Replace with function body.


func _on_name_text_changed(new_text):
	(%AlreadyUsed as Label).modulate = Color(255, 255, 255, 0)
	pass # Replace with function body.
