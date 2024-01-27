class_name Entity
extends CharacterBody2D


@export var max_life: int = 1

@onready var life: int = max_life:
	set(value):
		if life == value: return
		
		life = value
		if life <= 0:
			_on_death()


func _on_death():
	queue_free()


func _ready(): pass


func _physics_process(delta: float): pass


func _process(delta: float): pass
