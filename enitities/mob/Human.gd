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

# Called when the node enters the scene tree for the first time.
func _ready():
	(%Vision as Area2D).body_entered.connect(seeSomething)
	(%Hearing as Area2D).body_entered.connect(hearSomathing)
	attacked.connect(_on_attacked)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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

func _on_attacked():
	self.die()
