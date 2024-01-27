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
@export var staminaRecorvery: float = 1.0
@export var min_stamina: float = 4.0
var isRunning: bool = false

@export var currentStamina: float = stamina

var target: CharacterBody2D

var targetMode: ETargetMode = ETargetMode.WALK

var speed: float:
	get: return runSpeed if isRunning else walkSpeed

func toggleRun(value: bool) -> bool:
	if value and currentStamina < min_stamina:
		return false
	isRunning = value
	return true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(target) == false:
		target = null
	if isRunning:
		currentStamina = clamp(currentStamina - delta, 0.0, stamina)
		if currentStamina == 0.0:
			toggleRun(false)
	else:
		currentStamina = clamp(currentStamina + staminaRecorvery * delta, 0.0, stamina)

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
