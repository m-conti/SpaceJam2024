extends TileMap
class_name Map

const RIGID_LAYER = 2
const TERRAIN_LAYER = 1
const BACKGROUND_LAYER = 0

var last_mouse_map_pos = null
var cells := {}
var chunck_generated := Set.new()
var thread: Thread = Thread.new()

@onready var background_generator: BackgroundGenerator = $BackgroundGenerator

signal mouse_map_pos_changed(last_pos, new_pos: Vector2i)
signal mouse_map_pos_clicked(pos: Vector2i)


func _exit_tree():
	thread.wait_to_finish()


func _ready():
	Game.map = self


func _input(event) -> void:
	if event is InputEventMouseMotion:
		var current_mouse_map_pos: Vector2i = mouse_map_pos()

		if last_mouse_map_pos != current_mouse_map_pos:
			mouse_map_pos_changed.emit(last_mouse_map_pos, current_mouse_map_pos)
			last_mouse_map_pos = current_mouse_map_pos
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var current_mouse_map_pos: Vector2i = mouse_map_pos()

		mouse_map_pos_clicked.emit(current_mouse_map_pos)


func mouse_map_pos() -> Vector2i:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var map_pos: Vector2i = local_to_map(to_local(mouse_pos))
	return map_pos


func is_space_empty(pos: Vector2i, pattern_poses: Array) -> bool:
	for pattern_pos in pattern_poses:
		if get_cell(pos + pattern_pos) != null:
			return false
	return true


func can_move(pos: Vector2i) -> bool:
	var cell = get_cell(pos)

	if cell is Vector4i:
		if cell.x < 0 or cell.w < 0:
			return true
		return not tile_set.get_source(cell.x).get_tile_data(Vector2i(cell.y, cell.z), cell.w).get_custom_data("is_rigid")

	return cell == null


func can_move_path(path: Array) -> bool:
	for pos in path:
		if not can_move(pos):
			return false
	return true


func get_cell_attrs_from_pattern(pattern: TileMapPattern, cell_pos_in_pattern: Vector2i) -> Vector4i:
	var atlas_pos: Vector2i = pattern.get_cell_atlas_coords(cell_pos_in_pattern)
	return Vector4i(pattern.get_cell_source_id(cell_pos_in_pattern), atlas_pos.x, atlas_pos.y, pattern.get_cell_alternative_tile(cell_pos_in_pattern))


func place_pattern(layer: int, pos: Vector2i, house: TileMapPattern) -> void:
	set_pattern(layer, pos, house)
	for cell in house.get_used_cells():
		var new_pos: Vector2i = pos + cell
		cells[new_pos] = get_cell_attrs_from_pattern(house, cell)


func get_cell(pos: Vector2i):
	return cells.get(pos)


func generate_chunck_around(chunck: Vector2i):
	thread.wait_to_finish()

	for chunck_x in range(chunck.x - 2, chunck.x + 2):
		for chunck_y in range(chunck.y - 2, chunck.y + 2):
			for x in range(background_generator.chunck_size.x):
				for y in range(background_generator.chunck_size.y):
					var cell := Vector2i(x, y) + Vector2i(chunck_x, chunck_y) * background_generator.chunck_size
		
					set_cell(BACKGROUND_LAYER, cell, 0, background_generator.grass_cells.pick_random())

	thread.start(func():
		for x in range(chunck.x - 2, chunck.x + 2):
			for y in range(chunck.y - 2, chunck.y + 2):
				background_generator.generate_chunck(Vector2i(x, y))
	)
