extends Node2D
class_name Level

enum Tool {
	NONE = 0,
	KEY = 1,
	ARMOR = 2,
	HOVER = 3,
	PULL = 4,
}

@export var tilemap: TileMap
# 0 = Player, Rest = Inventory 
@export var all_tools: Array[Tool] = [Tool.NONE]
@export var cell_map: CellMap

var player_pos: Vector2i = Vector2i.ZERO
var cell_size: float = 0.0
var paused: bool = false
var inventory_mode: bool = false

signal init_ui(all_tools: Array[Tool], cell_size: float)
signal inventory_interaction(player_pos: Vector2, inventory_pos: Vector2, direction_from_player: Vector2)
signal player_moved(player_pos: Vector2, inventory_below: bool)
signal level_finished()

func _ready():
	var player_cells: Array[Vector2i] = tilemap.get_used_cells_by_id(0, -1, cell_map.PLAYER)
	if player_cells.size() == 0:
		print_debug("No Players Found!")
		pause()
		return
	player_pos = player_cells[0]
	cell_size = tilemap.rendering_quadrant_size * tilemap.scale.x
	init_ui.emit(all_tools, cell_size)
	player_moved.emit(player_pos * cell_size, tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.DOWN) == cell_map.INVENTORY)

func _process(_delta):
	if Input.is_action_just_pressed("Move.Up"):
		move_player(Vector2i.UP)
	elif Input.is_action_just_pressed("Move.Down"):
		move_player(Vector2i.DOWN)
	elif Input.is_action_just_pressed("Move.Left"):
		move_player(Vector2i.LEFT)
	elif Input.is_action_just_pressed("Move.Right"):
		move_player(Vector2i.RIGHT)
	elif Input.is_action_just_pressed("Interact"):
		interact()
	elif Input.is_action_just_pressed("Back"):
		if inventory_mode:
			inventory_interaction.emit(Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
			inventory_mode = not inventory_mode
			return
		pause()
		# Show pause UI

func pause():
	paused = true
	get_tree().paused = true

func fail():
	pause()
	# Show fail screen or some other indication

func succeed():
	level_finished.emit()
	pause()

func interact():
	if tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.UP) == cell_map.INVENTORY:
		inventory_interaction.emit(player_pos * cell_size, (player_pos + Vector2i.UP) * cell_size, Vector2.UP)
		inventory_mode = not inventory_mode
	if tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.DOWN) == cell_map.INVENTORY:
		inventory_interaction.emit(player_pos * cell_size, (player_pos + Vector2i.DOWN) * cell_size, Vector2.DOWN)
		inventory_mode = not inventory_mode
	if tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.LEFT) == cell_map.INVENTORY:
		inventory_interaction.emit(player_pos * cell_size, (player_pos + Vector2i.LEFT) * cell_size, Vector2.LEFT)
		inventory_mode = not inventory_mode
	if tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.RIGHT) == cell_map.INVENTORY:
		inventory_interaction.emit(player_pos * cell_size, (player_pos + Vector2i.RIGHT) * cell_size, Vector2.RIGHT)
		inventory_mode = not inventory_mode
	
	if all_tools[0] != Tool.KEY:
		return
	if tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.UP) == cell_map.DOOR:
		tilemap.set_cell(0, player_pos + Vector2i.UP)
	if tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.DOWN) == cell_map.DOOR:
		tilemap.set_cell(0, player_pos + Vector2i.DOWN)
	if tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.LEFT) == cell_map.DOOR:
		tilemap.set_cell(0, player_pos + Vector2i.LEFT)
	if tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.RIGHT) == cell_map.DOOR:
		tilemap.set_cell(0, player_pos + Vector2i.RIGHT)

func move_player(direction: Vector2i):
	if inventory_mode:
		return
	var new_cell: Vector2i = player_pos + direction
	if try_push_to_cell(new_cell, direction):
		player_pos = new_cell
	player_moved.emit(player_pos * cell_size, tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.DOWN) == cell_map.INVENTORY)

func try_push_to_cell(cell: Vector2i, direction: Vector2i) -> bool:
	var previous_cell_type: Vector2i = tilemap.get_cell_atlas_coords(0, cell - direction)
	var current_cell_type: Vector2i = tilemap.get_cell_atlas_coords(0, cell)
	if current_cell_type == cell_map.WALL or current_cell_type == cell_map.DOOR:
		return false
	if current_cell_type == cell_map.EMPTY or try_push_to_cell(cell + direction, direction):
		tilemap.set_cell(0, cell, 0, previous_cell_type)
		if previous_cell_type == cell_map.PLAYER:
			tilemap.set_cell(0, cell - direction)
		process_cell_triggers(cell, previous_cell_type)
		return true
	return false

func process_cell_triggers(cell: Vector2i, triggerer_type: Vector2i) -> void:
	var cell_type: Vector2i = tilemap.get_cell_atlas_coords(1, cell)
	if cell_type == cell_map.EMPTY:
		return
	if cell_type == cell_map.HOLE:
		if triggerer_type == cell_map.PLAYER:
			# Remember to actually pause the gameplay when
			# the player fails! Not doing so will surely
			# result in bugs.
			if all_tools[0] == Tool.HOVER:
				return
			fail()
		tilemap.set_cell(0, cell)
	if triggerer_type == cell_map.PLAYER:
		if cell_type == cell_map.SPIKES and not all_tools[0] == Tool.ARMOR:
			fail()
		if cell_type == cell_map.FINISH:
			succeed()

func _on_ui_handler_drag_and_drop_done(from_slot, to_slot):
	var tool: Tool = all_tools[to_slot]
	all_tools[to_slot] = all_tools[from_slot]
	all_tools[from_slot] = tool
	if from_slot == 0:
		process_cell_triggers(player_pos, cell_map.PLAYER)
