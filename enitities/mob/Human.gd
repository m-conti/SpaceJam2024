extends Mob
class_name Human


# Called when the node enters the scene tree for the first time.
func _ready():
	(%Vision as Area2D).body_entered.connect(seeSomething)
	(%Hearing as Area2D).body_entered.connect(hearSomathing)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func seeSomething(body: CharacterBody2D):
	print(body)

func hearSomathing(body: CharacterBody2D):
	print(body)
