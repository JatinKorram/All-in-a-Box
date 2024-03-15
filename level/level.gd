extends Node2D

enum Tool {
	NONE = 0,
	ARMOR = 1,
	HOVER = 2,
	KEY = 3,
}

@export var tilemap: TileMap
@export var player_pos: Vector2i = Vector2i.ZERO
@export var player_active_tool: Tool = Tool.NONE

@export var inventory_tools: Array = []

@export var CELL_EMPTY: Vector2i = Vector2i(-1, -1)
@export var CELL_PLAYER: Vector2i = Vector2i(1, 0)
@export var CELL_INVENTORY: Vector2i = Vector2i(2, 0)
@export var CELL_IMMOVABLE: Vector2i = Vector2i(0, 1)
@export var CELL_FINISH: Vector2i = Vector2i(1, 1)
@export var CELL_SPIKES: Vector2i = Vector2i(2, 1)
@export var CELL_HOLE: Vector2i = Vector2i(2, 2)
@export var CELL_DOOR: Vector2i = Vector2i(1, 2)

var cell_size: float = 0.0
var paused: bool = false

func _ready():
	cell_size = tilemap.rendering_quadrant_size * tilemap.scale.x

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
		pause()
		# Show pause UI

func pause():
	paused = true
	get_tree().paused = true

func fail():
	pause()
	# Show fail screen

func succeed():
	pause()
	# Show win screen

func interact():
	if tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.UP) == CELL_INVENTORY or tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.DOWN) == CELL_INVENTORY or tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.LEFT) == CELL_INVENTORY or tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.RIGHT) == CELL_INVENTORY:
		print_debug("Open Inventory!")
	
	if player_active_tool != Tool.KEY:
		return
	if tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.UP) == CELL_DOOR:
		tilemap.set_cell(0, player_pos + Vector2i.UP)
	if tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.DOWN) == CELL_DOOR:
		tilemap.set_cell(0, player_pos + Vector2i.DOWN)
	if tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.LEFT) == CELL_DOOR:
		tilemap.set_cell(0, player_pos + Vector2i.LEFT)
	if tilemap.get_cell_atlas_coords(0, player_pos + Vector2i.RIGHT) == CELL_DOOR:
		tilemap.set_cell(0, player_pos + Vector2i.RIGHT)

func move_player(direction: Vector2i):
	var new_cell: Vector2i = player_pos + direction
	if try_push_to_cell(new_cell, direction):
		player_pos = new_cell

func try_push_to_cell(cell: Vector2i, direction: Vector2i) -> bool:
	var previous_cell_type: Vector2i = tilemap.get_cell_atlas_coords(0, cell - direction)
	var current_cell_type: Vector2i = tilemap.get_cell_atlas_coords(0, cell)
	if current_cell_type == CELL_IMMOVABLE or current_cell_type == CELL_DOOR:
		return false
	if current_cell_type == CELL_EMPTY or try_push_to_cell(cell + direction, direction):
		tilemap.set_cell(0, cell, 0, previous_cell_type)
		if previous_cell_type == CELL_PLAYER:
			tilemap.set_cell(0, cell - direction)
		process_cell_triggers(cell, previous_cell_type)
		return true
	return false

func process_cell_triggers(cell: Vector2i, triggerer_type: Vector2i) -> void:
	var cell_type: Vector2i = tilemap.get_cell_atlas_coords(1, cell)
	if cell_type == CELL_EMPTY:
		return
	if cell_type == CELL_HOLE:
		if triggerer_type == CELL_PLAYER:
			# Remember to actually pause the gameplay when
			# the player fails! Not doing so will surely
			# result in bugs.
			if player_active_tool == Tool.HOVER:
				return
			fail()
		tilemap.set_cell(0, cell)
	if triggerer_type == CELL_PLAYER:
		if cell_type == CELL_SPIKES and not player_active_tool == Tool.ARMOR:
			print_debug("Fail!")
			fail()
		if cell_type == CELL_FINISH:
			print_debug("Finish!")
			succeed()
