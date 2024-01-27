class_name Spawner
extends Timer


@export var entity_to_spawn: PackedScene
@export var spawn_count := Vector2i(1, 10)
@export var min_spawn_dist := Vector2i(20, 20)
@export var max_spawn_dist := Vector2i(50, 50)

@export var spawn_range := Vector2i(5, 5)

@onready var map: Map = %Map


func _on_timeout() -> void:
	spawn_around(%Player)


func get_spawnable_map_pos_around(map_pos: Vector2i, min_radius: Vector2i, max_radius: Vector2i) -> Vector2i:
	var spawnable = false
	var spawnable_map_pos := Vector2i()

	while not spawnable:
		spawnable_map_pos = map_pos + Vector2i(randi_range(min_radius.x, max_radius.x), randi_range(min_radius.y, max_radius.y))
		spawnable = map.can_move(spawnable_map_pos)
	
	return spawnable_map_pos


func spawn_around(entity: Node2D) -> void:
	var spawnable_map_pos: Vector2i = get_spawnable_map_pos_around(map.local_to_map(entity.position), min_spawn_dist, max_spawn_dist)

	var nb_zombies = randi_range(spawn_count.x, spawn_count.y)
	for i in range(nb_zombies):
		spawnable_map_pos = get_spawnable_map_pos_around(spawnable_map_pos, -spawn_range, spawn_range)

		var entity_instance = entity_to_spawn.instantiate()
		entity_instance.global_position = map.to_global(map.map_to_local(spawnable_map_pos))
		map.get_parent().add_child(entity_instance)
