class_name Gun
extends Node2D


@export var bullet_speed: float = 100.0
@export var shoot_delay: float = 0.5

@onready var entity: Node2D = get_parent()

var bullet_scene: PackedScene = preload("res://Weapon/Bullet.tscn")


func _ready():
	%Timer.wait_time = shoot_delay


func _on_timeout():
	if entity.get_parent().target:
		shoot()


func shoot():
	var bullet: Bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet)

	bullet.speed = bullet_speed
	bullet.direction_angle = global_rotation
	bullet.global_position = global_position
