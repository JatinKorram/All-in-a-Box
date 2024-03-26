extends TileMap
class_name Level

@export var cell_size: int = 16
@export var template_layer: int
@export var sprites_source_id: int
@export var info_map: TileInfoMap
@export var generated_colliders_padding: int = 2

func _enter_tree():
	Game.instance.connect("level_setup", _setup)

func _setup():
	_generate()

func _generate():
	var cells: Array[Vector2i] = get_used_cells_by_id(template_layer)
	set_layer_enabled(template_layer, false)
	var tile_atlas: TileSetAtlasSource = tile_set.get_source(sprites_source_id) as TileSetAtlasSource
	var hframes: int = tile_atlas.texture.get_width() / cell_size
	var vframes: int = tile_atlas.texture.get_height() / cell_size
	var collision_shape: RectangleShape2D = RectangleShape2D.new()
	collision_shape.size = Vector2.ONE * (cell_size - generated_colliders_padding)
	var collision_shape_offset: Vector2 = Vector2.ONE * cell_size / 2
	for cell: Vector2i in cells:
		var atlas_coords: Vector2i = get_cell_atlas_coords(template_layer, cell)
		for tile: TileInfo in info_map.tiles:
			if atlas_coords == tile.atlas_coords:
				var node: GeneratedTile = GeneratedTile.new()
				if tile.attached_script != null:
					node.set_script(tile.attached_script)
				node.grid_position = cell
				node.position = cell * cell_size
				if tile.is_trigger:
					node.monitorable = false
				else:
					node.monitoring = false
				node.collision_layer = tile.collision_layer
				node.collision_mask = tile.collision_mask
				var shape: CollisionShape2D = CollisionShape2D.new()
				shape.shape = collision_shape
				shape.position += collision_shape_offset
				node.add_child(shape)
				if tile.is_invisible:
					break
				var sprite: Sprite2D = Sprite2D.new()
				sprite.hframes = hframes
				sprite.vframes = vframes
				sprite.texture = tile_atlas.texture
				sprite.frame_coords = atlas_coords
				sprite.z_index = tile.z_index
				sprite.centered = false
				node.add_child(sprite)
				call_deferred("add_child", node)
				break

func push_cell(cell: Vector2i, direction: Vector2i) -> bool:
	return _push_cell(cell, direction, cell)

func _push_cell(cell: Vector2i, direction: Vector2i, origin: Vector2i) -> bool:
	if _try_push_cell(cell, direction, origin):
		set_cell(template_layer, cell + direction, sprites_source_id, get_cell_atlas_coords(0, cell))
		set_cell(sprites_source_id, cell)
		return true
	return false

func _try_push_cell(cell: Vector2i, direction: Vector2i, origin: Vector2i) -> bool:
	var next_atlas_coords: Vector2i = get_cell_atlas_coords(template_layer, cell + direction)
	if next_atlas_coords == Vector2i(-1, -1):
		_move_generated_nodes(origin, cell, direction)
		return true
	for tile: TileInfo in info_map.tiles:
		if next_atlas_coords == tile.atlas_coords:
			if tile.is_trigger:
				_move_generated_nodes(origin, cell, direction)
				return true
			return _push_cell(cell + direction, direction, origin)
	return false

func _move_generated_nodes(start_cell: Vector2i, end_cell: Vector2i, direction: Vector2i):
	for node: GeneratedTile in get_children():
		if not node.monitorable:
			continue
		var relative_pos: Vector2 = node.grid_position - start_cell
		if direction.y == 0 and relative_pos.y == 0:
			relative_pos.x *= direction.x
			if relative_pos.x >= 0 and relative_pos.x <= absi((start_cell - end_cell).x):
				node.move(direction)
			continue
		if direction.x == 0 and relative_pos.x == 0:
			relative_pos.y *= direction.y
			if relative_pos.y >= 0 and relative_pos.y <= absi((start_cell - end_cell).y):
				node.move(direction)
