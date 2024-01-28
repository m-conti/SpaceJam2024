class_name Graph


class Edge:
	var u: Vector2i
	var v: Vector2i
	var weight: float

	func _init(u: Vector2i, v: Vector2i, weight: float):
		self.u = u
		self.v = v
		self.weight = weight

	func _to_string():
		return str(self.u) + " -> " + str(self.v) + " : " + str(self.weight)


static func find_set_root(parent, node):
	while node != parent[node]:
		node = parent[node]
	return node


static func kruskal(poses: Array) -> Array:
	var edges: Array = []
	var parent: Dictionary = {}

	for pos in poses:
		parent[pos] = pos

	for i in range(poses.size()):
		for j in range(i + 1, poses.size()):
			var u = poses[i]
			var v = poses[j]
			var weight = heuristic(u, v)
			edges.append(Edge.new(u, v, weight))

	edges = Iterator.sort(edges, func(x): return x.weight)

	var min_spanning_tree: Array = []

	for edge in edges:
		var u = edge.u
		var v = edge.v

		if find_set_root(parent, u) != find_set_root(parent, v):
			min_spanning_tree.append(edge)
			parent[find_set_root(parent, u)] = find_set_root(parent, v)

	return min_spanning_tree


static func movable_cases(map: Map, start_pos: Vector2i, max_depth: int, all_movable_cases: Set = Set.new(), include_start_pos: bool = true) -> Set:
	if max_depth < 0:
		return Set.new()

	var movable_cases: Set = Set.from([start_pos]) if include_start_pos else Set.new()
	var open_set: Set = Set.new()
	var closed_set: Set = Set.new()
	var depth: Dictionary = {}
	
	open_set.add(start_pos)
	depth[start_pos] = 0
	
	while not open_set.is_empty():
		var current = open_set.pop_front()
		
		if depth[current] >= max_depth:
			continue
		
		closed_set.add(current)
		
		for neighbor in get_neighbors(map, current, all_movable_cases):
			if closed_set.has(neighbor):
				continue
			
			if not open_set.has(neighbor):
				open_set.add(neighbor)
				depth[neighbor] = depth[current] + 1
			
			if all_movable_cases.has(neighbor) or map.can_move(neighbor):
				movable_cases.add(neighbor)
	
	return movable_cases


static func a_star(map: Map, start_pos: Vector2i, end_pos: Vector2i, movable_cases: Set = Set.new(), include_start_pos: bool = true) -> Array:
	if start_pos == end_pos:
		return [start_pos] if include_start_pos else []

	var open_set: Set = Set.new()
	var closed_set: Set = Set.new()
	var g_score: Dictionary = {}
	var f_score: Dictionary = {}
	var parent: Dictionary = {}
	
	for x in range(map.background_generator.chunck_size.x + 5):
		for y in range(map.background_generator.chunck_size.y + 5):
			g_score[Vector2i(x, y)] = INF
			f_score[Vector2i(x, y)] = INF
	
	g_score[start_pos] = 0
	f_score[start_pos] = heuristic(start_pos, end_pos)
	open_set.add(start_pos)
	
	while not open_set.is_empty():
		var current = get_lowest_f_score(open_set, f_score)
		
		if current == end_pos:
			var path: Array = reconstruct_path(parent, current)
			return [start_pos] + path if include_start_pos else path
		
		open_set.erase(current)
		closed_set.add(current)
		
		for neighbor in get_neighbors(map, current, movable_cases):
			if closed_set.has(neighbor):
				continue
			
			var tentative_g_score = g_score[current] + (current - neighbor).length()
			
			if not open_set.has(neighbor) or tentative_g_score < g_score[neighbor]:
				parent[neighbor] = current
				g_score[neighbor] = tentative_g_score
				f_score[neighbor] = g_score[neighbor] + heuristic(neighbor, end_pos)
				
				if not open_set.has(neighbor):
					open_set.add(neighbor)
	
	return []  # No Path Found


static func get_lowest_f_score(open_set: Set, f_score: Dictionary):
	var lowest_f: float = INF
	var lowest_node = null
	
	for node in open_set.values:
		if f_score[node] < lowest_f:
			lowest_f = f_score[node]
			lowest_node = node
	
	return lowest_node


static func heuristic(node: Vector2i, end_pos: Vector2i) -> float:
	return (node - end_pos).length()


static func get_neighbors(map: Map, node: Vector2i, movable_cases: Set = Set.new()) -> Array:
	var neighbors = []
	var directions = [Vector2i.LEFT, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.UP]
	
	for dir in directions:
		var neighbor: Vector2i = node + dir
		
		if movable_cases.has(neighbor) or map.can_move(neighbor):
			neighbors.append(neighbor)
	
	return neighbors


static func reconstruct_path(parent, current) -> Array:
	var new_path: Array = [current]
	if not parent.has(current):
		return new_path
	
	while parent.has(parent[current]):
		current = parent[current]
		new_path.push_front(current)
	
	return new_path
