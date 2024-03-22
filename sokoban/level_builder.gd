extends Node2D
class_name LevelBuilder

@export var sprite_source_id: int
@export var tiles: Array[TileInfo]

var generated_nodes: Array[Area2D]

# TODO: Make the target tilemap layer, the source id, and other stuff editable
#		i.e. make them NOT hard-coded.

func build(tilemap: TileMap, cell_size: int):
	var cells: Array[Vector2i] = tilemap.get_used_cells_by_id(0)
	tilemap.set_layer_enabled(0, false)
	var tile_atlas: TileSetAtlasSource = tilemap.tile_set.get_source(0) as TileSetAtlasSource
	var hframes: int = tile_atlas.texture.get_width() / cell_size
	var vframes: int = tile_atlas.texture.get_height() / cell_size
	var collision_shape: RectangleShape2D = RectangleShape2D.new()
	collision_shape.size = Vector2.ONE * cell_size
	for cell: Vector2i in cells:
		var atlas_coords: Vector2i = tilemap.get_cell_atlas_coords(0, cell)
		for tile: TileInfo in tiles:
			if atlas_coords == tile.atlas_coords:
				var node: Area2D = Area2D.new()
				node.position = cell * cell_size
				if tile.collision:
					node.monitoring = false
				else:
					node.monitorable = false
				node.set_script(tile.attached_script)
				generated_nodes.push_back(node)
				add_child(node)
				var shape: CollisionShape2D = CollisionShape2D.new()
				shape.shape = collision_shape
				node.add_child(shape)
				var sprite: Sprite2D = Sprite2D.new()
				sprite.hframes = hframes
				sprite.vframes = vframes
				sprite.texture = tile_atlas.texture
				sprite.frame_coords = atlas_coords
				node.add_child(sprite)
				break
