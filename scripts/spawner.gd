class_name Spawner
extends Timer


var entity_to_spawn := {
	preload("res://entities/mob/Human.tscn"): 1.0,
	preload("res://entities/mob/Hunter.tscn"): 1.0,
}

@export var spawn_count := Vector2i(1, 10)
@export var min_spawn_dist: float = 20.0
@export var max_spawn_dist: float = 50.0

@export var spawn_range: float = 10.0

@onready var map: Map = %Map


func get_entity_to_spawn() -> PackedScene:
	var total_weight: float = 0.0
	for entity in entity_to_spawn:
		total_weight += entity_to_spawn[entity]

	var random_weight: float = randf_range(0.0, total_weight)
	for entity in entity_to_spawn:
		random_weight -= entity_to_spawn[entity]
		if random_weight <= 0.0:
			return entity
	
	return null


func _on_timeout() -> void:
	spawn_around(%Player)


func get_random_pos_in_range(min_radius: float, max_radius: float) -> Vector2i:
	var angle = randf_range(0.0, TAU)
	var radius = randf_range(min_radius, max_radius)

	return Vector2i(round(radius * cos(angle)), round(radius * sin(angle)))


func get_spawnable_map_pos_around(map_pos: Vector2i, min_radius: float, max_radius: float) -> Vector2i:
	var spawnable := false
	var spawnable_map_pos := Vector2i()

	while not spawnable:
		spawnable_map_pos = map_pos + get_random_pos_in_range(min_radius, max_radius)
		spawnable = map.can_move(spawnable_map_pos)
	
	return spawnable_map_pos


func spawn_around(entity: Node2D) -> void:
	var entity_map_pos: Vector2i = map.local_to_map(map.to_local(entity.global_position))
	var spawnable_map_pos: Vector2i = get_spawnable_map_pos_around(entity_map_pos, min_spawn_dist, max_spawn_dist)

	var nb_zombies = randi_range(spawn_count.x, spawn_count.y)
	for i in range(nb_zombies):
		spawnable_map_pos = get_spawnable_map_pos_around(spawnable_map_pos, -spawn_range, spawn_range)

		var entity_instance = get_entity_to_spawn().instantiate()
		entity_instance.global_position = map.to_global(map.map_to_local(spawnable_map_pos))
		map.get_parent().add_child(entity_instance)
