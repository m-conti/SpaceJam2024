extends Entity
class_name Mob

enum ETargetMode {
	FLEE,
	ATTACK,
	WANDER,
}

@export var walkSpeed: float = 6000.0
@export var runSpeed: float = 10000.0
@export var stamina: float = 10.0
@export var staminaRecorvery: float = 1.0
@export var min_stamina: float = 4.0
@export var wander_refresh_time: float = 1.0
@export var dispawn_distance: float = 1000.0

var isRunning: bool = false

@onready var currentStamina: float = stamina

var wander_direction := Vector2.ZERO
var target_pos: Vector2:
	get: return (global_position + wander_direction*10.0) if targetMode == ETargetMode.WANDER else target.position

var target: CharacterBody2D:
	set(value):
		target = value
		if target == null:
			targetMode = ETargetMode.WANDER

var wander_timer: Timer
var targetMode: ETargetMode = ETargetMode.WANDER:
	set(value):
		if targetMode == value:
			return
		
		targetMode = value
		if targetMode == ETargetMode.WANDER:
			create_wander_timer()
		elif wander_timer != null:
			wander_timer.queue_free()
			wander_timer = null

var speed: float:
	get: return runSpeed if isRunning else walkSpeed


func toggleRun(value: bool) -> bool:
	if value and currentStamina < min_stamina:
		return false
	isRunning = value
	return true


func get_random_direction():
	var angle = randf_range(0.0, TAU)
	return Vector2(cos(angle), sin(angle))


func create_wander_timer():
	wander_direction = get_random_direction()
	wander_timer = Timer.new()
	wander_timer.set_wait_time(wander_refresh_time)
	wander_timer.autostart = true
	wander_timer.timeout.connect(func(): wander_direction = get_random_direction())
	add_child(wander_timer)


func _ready():
	super._ready()
	create_wander_timer()


func _process(delta):
	super._process(delta)
	if (global_position - Game.player.global_position).length_squared() > dispawn_distance**2:
		queue_free()

	if not is_instance_valid(target):
		target = null
	
	if isRunning:
		currentStamina = clamp(currentStamina - delta, 0.0, stamina)
		if currentStamina == 0.0:
			toggleRun(false)
	else:
		currentStamina = clamp(currentStamina + staminaRecorvery * delta, 0.0, stamina)


func _physics_process(delta):
	super._physics_process(delta)
	if targetMode != ETargetMode.WANDER and target == null:
		return

	var direction = getDirectionByTargetMode()
	direction = direction.normalized()

	velocity = direction * speed * delta

	move_and_slide()


func getDirectionByTargetMode():
	if targetMode == ETargetMode.FLEE:
		return position - target_pos
	elif targetMode == ETargetMode.ATTACK:
		return target_pos - position
	elif targetMode == ETargetMode.WANDER:
		return -wander_direction
