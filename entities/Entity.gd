class_name Entity
extends CharacterBody2D


@onready var life_progress_bar: ProgressBar = %LifeProgressBar
@onready var stamina_progress_bar: ProgressBar = %StaminaProgressBar

@export var staminaRecorvery: float = 1.0
@export var walkSpeed: float = 6000.0
@export var runSpeed: float = 16000.0

var isRunning: bool = false

var speed: float:
	get: return runSpeed if isRunning else walkSpeed

@export var max_life: int = 1:
	set(value):
		if max_life == value: return
		
		var diff: int = value - max_life
		diff = diff if diff > 0 else 0

		max_life = value
		_on_life_changed()
		life += diff 

@onready var life: int = max_life:
	set(value):
		if life == value: return
		
		life = value
		_on_life_changed()
		if life <= 0:
			_on_death()


@export var max_stamina: float = 10.0:
	set(value):
		if max_stamina == value: return
		
		var diff: float = value - max_stamina
		diff = diff if diff > 0.0 else 0.0

		max_stamina = value
		_on_stamina_changed()
		stamina += diff

@export var min_stamina: float = 4.0:
	set(value):
		if min_stamina == value: return
		
		min_stamina = value
		_on_stamina_changed()

@onready var stamina: float = max_stamina:
	set(value):
		if stamina == value: return
		
		stamina = value
		_on_stamina_changed()


func _on_stamina_changed():
	if stamina_progress_bar == null: return

	Anim.animate(stamina_progress_bar, "max_value", max_stamina, 0.5)
	Anim.animate(stamina_progress_bar, "value", stamina, 0.5)


func _on_life_changed():
	if life_progress_bar == null: return

	Anim.animate(life_progress_bar, "max_value", max_life, 0.5)
	Anim.animate(life_progress_bar, "value", life, 0.5)


func _on_death():
	queue_free()


func _ready():
	life_progress_bar.max_value = max_life
	life_progress_bar.value = life
	stamina_progress_bar.max_value = max_stamina
	stamina_progress_bar.value = stamina


func _physics_process(delta: float):
	if isRunning:
		stamina = clamp(stamina - delta, 0.0, max_stamina)
		if stamina == 0.0:
			toggleRun(false)
	else:
		stamina = clamp(stamina + staminaRecorvery * delta, 0.0, max_stamina)


func _process(delta: float): pass


func toggleRun(value: bool) -> bool:
	if value and stamina < min_stamina:
		return false
	isRunning = value
	return true
