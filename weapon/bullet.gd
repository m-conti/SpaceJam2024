class_name Bullet
extends Area2D


@export var speed: float = 400.0
@export var life_span: float = 2.0
@export var damage: int = 1

@onready var timer: Timer = %Timer


func _physics_process(delta):
	position.x += speed * delta


func _on_body_entered(body: Node2D):
	if body is Entity:
		body.life -= damage
	
	queue_free()
