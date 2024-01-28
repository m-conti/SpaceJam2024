extends Entity
class_name Mob

enum ETargetMode {
	FLEE,
	ATTACK,
	WANDER,
}

@export var wander_refresh_time: float = 1.0
@export var dispawn_distance: float = 1000.0
@export var group_up_distance: float = 100.0

var wander_direction := Vector2.ZERO
var target_pos: Vector2:
	get:
		if targetMode == ETargetMode.WANDER:
			return global_position + wander_direction
		if is_instance_valid(target):
			return target.global_position
		return global_position

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

var entity_group: String:
	get = get_entity_group


static func get_entity_group():
	return "mob"


func get_random_direction():
	var close_entities: Array = get_tree().get_nodes_in_group(entity_group).filter(
		func(e: Node2D):
			return e != self and e.global_position.distance_to(global_position) < group_up_distance
	)
	var barycentre: Vector2 = close_entities.reduce(
		func(acc: Vector2, e: Node2D):
			return acc + e.global_position,
		Vector2.ZERO
	)

	var angle = randf_range(0.0, TAU)
	return 20.0*Vector2(cos(angle), sin(angle)) + barycentre - global_position


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


func _physics_process(delta):
	super._physics_process(delta)
	if targetMode != ETargetMode.WANDER and target == null:
		return

	velocity = get_direction().normalized() * speed * delta
	move_and_slide()


func get_direction():
	if targetMode == ETargetMode.FLEE:
		return position - target_pos
	elif targetMode == ETargetMode.ATTACK:
		return target_pos - position
	elif targetMode == ETargetMode.WANDER:
		return -wander_direction
