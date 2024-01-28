class_name Spawner
extends Timer


const entity_to_spawn := [
	preload("res://entities/mob/Human/FearHuman.tscn"),
	preload("res://entities/mob/Human/Hunter.tscn"),
]

@export var spawn_count := Vector2i(1, 10)
@export var min_spawn_dist: float = 20.0
@export var max_spawn_dist: float = 50.0
@export var human_cap: int = 30

@export var spawn_range: float = 10.0
## The higher the difficulty_scale, the more difficult the game will be
@export var difficulty_scale: float = 1.0
## The higher the spawn_difficulty_variance, the more the difficulty will vary (> 1.0)
@export var spawn_difficulty_variance: float = 2.0

@onready var map: Map = %Map


func get_entity_to_spawn(difficulty: float) -> PackedScene:
	var weights: Dictionary = {}
	for entity in entity_to_spawn:
		weights[entity] = 1 / (1 + abs(difficulty - entity.score)**spawn_difficulty_variance)

	var total_weight: float = 0.0
	for entity in entity_to_spawn:
		total_weight += weights[entity]

	var random_weight: float = randf_range(0.0, total_weight)
	for entity in entity_to_spawn:
		random_weight -= weights[entity]
		if random_weight <= 0.0:
			return entity
	
	return null


func _on_timeout() -> void:
	if get_tree().get_nodes_in_group("human").size() > human_cap:
		return

	spawn_around(Game.player, Game.player.score * difficulty_scale / 100.0)


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


func spawn_around(entity: Node2D, difficulty: float) -> void:
	var entity_map_pos: Vector2i = map.local_to_map(map.to_local(entity.global_position))
	var spawnable_map_pos: Vector2i = get_spawnable_map_pos_around(entity_map_pos, min_spawn_dist, max_spawn_dist)

	var nb_zombies = randi_range(spawn_count.x, spawn_count.y)
	for i in range(nb_zombies):
		spawnable_map_pos = get_spawnable_map_pos_around(spawnable_map_pos, -spawn_range, spawn_range)

		var entity_instance = get_entity_to_spawn(difficulty).instantiate()
		entity_instance.upgrade(difficulty)
		entity_instance.global_position = map.to_global(map.map_to_local(spawnable_map_pos))
		map.get_parent().add_child(entity_instance)
