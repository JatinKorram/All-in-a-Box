extends Resource
class_name TileInfo

@export var name: String
@export var attached_script: Script = null
@export var atlas_coords: Vector2i = Vector2i(-1, -1)

@export_group("Visual")
@export var z_index: int = 0
@export var is_invisible: bool = false

@export_group("Physics")
@export var is_trigger: bool = false
@export_flags_2d_physics var collision_layer: int = 1
@export_flags_2d_physics var collision_mask: int = 1
