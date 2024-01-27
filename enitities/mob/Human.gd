extends Mob
class_name Human

enum EHumanType {
	FEARLESS,
	FEARFUL,
	AGGRESSIVE,
	DEFENSIVE,
	NEUTRAL
}

signal attacked

@export var _humanType: EHumanType = EHumanType.NEUTRAL
@export var zombie_scene: PackedScene


func _ready():
	(%Vision as Area2D).body_entered.connect(seeSomething)
	(%Hearing as Area2D).body_entered.connect(hearSomathing)
	attacked.connect(_on_attacked)


func _physics_process(delta):
	super._physics_process(delta)
	if target:
		changeLookAtByHumanType()


func seeSomething(body: CharacterBody2D):
	setTarget(body)


func hearSomathing(body: CharacterBody2D):
	setTarget(body)


func setTarget(body: CharacterBody2D):
	print("SET TARGET :", body, target)
	if not target:
		target = body
	elif body.position.distance_to(position) < target.position.distance_to(position):
		target = body
	if target == body:
		changeTargetModByHumanType()


func changeLookAtByHumanType():
	if _humanType == EHumanType.FEARLESS:
		(%Vision).look_at(target.position)
	elif _humanType == EHumanType.FEARFUL:
		(%Vision).look_at(target.position)
		(%Vision as Area2D).rotate(PI)
	elif _humanType == EHumanType.AGGRESSIVE:
		(%Vision).look_at(target.position)
	elif _humanType == EHumanType.DEFENSIVE:
		(%Vision).look_at(target.position)
	elif _humanType == EHumanType.NEUTRAL:
		(%Vision).look_at(target.position)
		(%Vision as Area2D).rotate(PI)


func changeTargetModByHumanType():
	if _humanType == EHumanType.FEARLESS:
		targetMode = ETargetMode.ATTACK
	elif _humanType == EHumanType.FEARFUL:
		targetMode = ETargetMode.FLY
	elif _humanType == EHumanType.AGGRESSIVE:
		targetMode = ETargetMode.ATTACK
	elif _humanType == EHumanType.DEFENSIVE:
		targetMode = ETargetMode.FLY
	elif _humanType == EHumanType.NEUTRAL:
		targetMode = ETargetMode.FLY
	print("CHANGE TARGET_MODE :", targetMode)


func die():
	self.queue_free()

	var zombie: Node2D = zombie_scene.instantiate()
	get_parent().add_child(zombie)
	
	zombie.position = position
	zombie.global_scale = global_scale


func _on_attacked():
	self.die()
