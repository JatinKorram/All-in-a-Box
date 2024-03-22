extends TileMap
class_name LevelManipulator

# TODO: Make the target tilemap layer, the source id, and other stuff editable
#		i.e. make them NOT hard-coded.

func push_cell(cell: Vector2i, direction: Vector2i):
	_push_cell(cell, direction, cell)

func _push_cell(cell: Vector2i, direction: Vector2i, origin: Vector2i) -> bool:
	if _try_push_cell(cell, direction, origin):
		set_cell(0, cell + direction, 0, get_cell_atlas_coords(0, cell))
		set_cell(0, cell)
		return true
	return false

func _try_push_cell(cell: Vector2i, direction: Vector2i, origin: Vector2i) -> bool:
	var next_atlas_coords: Vector2i = get_cell_atlas_coords(0, cell + direction)
	if next_atlas_coords == Vector2i(-1, -1):
		_move_generated_nodes(origin, cell, direction)
		return true
	for tile: TileInfo in Game.get_level_contents().level_builder.tiles:
		if next_atlas_coords == tile.atlas_coords:
			if not tile.collision:
				_move_generated_nodes(origin, cell, direction)
				return true
			return _push_cell(cell + direction, direction, origin)
	return false

func _move_generated_nodes(start_cell: Vector2i, end_cell: Vector2i, direction: Vector2i):
	var level: Level = Game.get_level_contents()
	var _start_cell: Vector2 = Vector2(start_cell) * level.cell_size
	var _end_cell: Vector2 = Vector2(end_cell) * level.cell_size
	for node: Area2D in level.level_builder.generated_nodes:
		if not node.monitorable:
			continue
		var relative_pos: Vector2 = node.position - _start_cell
		if direction.y == 0 and relative_pos.y == 0:
			relative_pos.x *= direction.x
			if relative_pos.x >= 0 and relative_pos.x <= absi((_start_cell - _end_cell).x):
				node.position += Vector2(direction) * level.cell_size
			continue
		if direction.x == 0 and relative_pos.x == 0:
			relative_pos.y *= direction.y
			if relative_pos.y >= 0 and relative_pos.y <= absi((_start_cell - _end_cell).y):
				node.position += Vector2(direction) * level.cell_size
