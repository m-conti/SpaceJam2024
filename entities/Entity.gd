class_name Entity
extends CharacterBody2D


@onready var progress_bar: ProgressBar = %ProgressBar


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


func _on_life_changed():
	if progress_bar == null: return

	Anim.animate(progress_bar, "max_value", max_life, 0.5)
	Anim.animate(progress_bar, "value", life, 0.5)


func _on_death():
	queue_free()


func _ready():
	progress_bar.max_value = max_life
	progress_bar.value = life


func _physics_process(delta: float): pass


func _process(delta: float): pass
