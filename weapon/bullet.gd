class_name Bullet
extends Area2D


@export var speed: float = 400.0
@export var life_span: float = 2.0
@export var damage: float = 1.5

@onready var timer: Timer = %Timer


var direction_angle: float = 0.0


func _physics_process(delta):
	position += Vector2(speed * delta, 0).rotated(direction_angle)


func _on_body_entered(body: Node2D):
	if body is Entity:
		body.life -= damage
	
	queue_free()
