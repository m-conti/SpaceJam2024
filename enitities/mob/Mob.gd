extends CharacterBody2D
class_name Mob

enum ETargetMode {
	FLY,
	ATTACK,
	WALK,
}

@export var walkSpeed: float = 6000.0
@export var runSpeed: float = 10000.0
@export var stamina: float = 10.0
var isRunning: bool = false

var target: CharacterBody2D

var targetMode: ETargetMode = ETargetMode.WALK

var speed: float:
	get: return runSpeed if isRunning else walkSpeed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(target) == false:
		target = null

func _physics_process(delta):
	if target == null:
		return

	var direction = getDirectionByTargetMode()
	direction = direction.normalized()

	velocity = direction * speed * delta
	move_and_slide()

func getDirectionByTargetMode():
	if targetMode == ETargetMode.FLY:
		return position - target.position
	elif targetMode == ETargetMode.ATTACK:
		return target.position - position
	elif targetMode == ETargetMode.WALK:
		return target.position - position
	else:
		return Vector2.ZERO
