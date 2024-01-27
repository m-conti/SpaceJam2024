extends CharacterBody2D


@export var walkSpeed: float = 6000.0
@export var runSpeed: float = 10000.0
@export var stamina: float = 10.0
var isRunning: bool = false

var speed: float:
	get: return runSpeed if isRunning else walkSpeed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("run"):
		self.toggleRun(true)
	if event.is_action_released("run"):
		self.toggleRun(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func toggleRun(value: bool):
	isRunning = value
	set_collision_layer_value(5, value)
	pass

func _physics_process(delta):
	var direction = Vector2()
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	velocity = direction.normalized() * speed * delta
	move_and_slide()
