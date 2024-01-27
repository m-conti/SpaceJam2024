class_name Iterator


static func sort(a, key = null) -> Array:
	if key == null:
		key = func(x): return x
	
	var map = a.map(key)
	var indices = range(a.size())
	indices.sort_custom(func(x, y): return map[x] < map[y])

	return indices.map(func(x): return a[x])
