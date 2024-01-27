class_name BackgroundGenerator
extends Node2D


@export var nb_houses_per_chunck := Vector2i(10, 15)
@export var chunck_size := Vector2i(100, 100)

@export var grass_cells: Array[Vector2i] = []

@onready var map: Map = get_parent()


func create_houses(chunck: Vector2i) -> Array:
	var entrances: Array = []

	for i in range(randi_range(nb_houses_per_chunck.x, nb_houses_per_chunck.y)):
		var house_id: int = randi() % (map.tile_set.get_patterns_count() - 1)
		var house: TileMapPattern = map.tile_set.get_pattern(house_id)

		var pos: Vector2i

		while true:
			pos = Vector2i(randi_range(0, chunck_size.x), randi_range(0, chunck_size.y)) + chunck * chunck_size

			if map.is_space_empty(pos, house.get_used_cells()):
				break
			
		map.place_pattern(map.RIGID_LAYER, pos, house)
		entrances.append(pos + Vector2i.DOWN*house.get_size() + Vector2i.RIGHT)
	
	return entrances


func generate_chunck(chunck: Vector2i) -> void:
	if map.chunck_generated.has(chunck):
		return
	
	map.chunck_generated.add(chunck)

	var entrances: Array = create_houses(chunck)

	var tree: Array = Graph.kruskal(entrances)

	for edge in tree:
		var path: Array = Graph.a_star(map, edge.u, edge.v)
		map.set_cells_terrain_path(map.TERRAIN_LAYER, path, 0, 0)
	
	var used_cell: Set = Set.from(map.get_used_cells(map.TERRAIN_LAYER))

	for x in range(-1, map.size.x + 1):
		for y in range(-1, map.size.y + 1):
			var cell: Vector2i = Vector2i(x, y)
			if used_cell.has(cell):
				continue
			
			# map.set_cell(map.TERRAIN_LAYER, cell, 0, grass_cells.pick_random())
