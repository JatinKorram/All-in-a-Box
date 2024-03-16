extends Control
class_name UIHandler

@export var slots: Control = null
@export var next_button: Button = null

var slot_sprites: Array[Sprite2D] = []
var slot_sprite_size: float = 0
var mouse_held_sprite: Sprite2D = null
var mouse_held_sprite_index: int = -1
var mouse_held_sprite_original_global_pos: Vector2 = Vector2.ZERO

@onready var slot_resource: Resource = preload("res://ui/slot.tscn")

signal drag_and_drop_done(from_slot: int, to_slot: int)

func _on_tests_init_ui(all_tools: Array[Level.Tool], cell_size: float):
	slot_sprite_size = cell_size / 3
	slot_sprites.resize(all_tools.size() + 1)
	for i in range(0, all_tools.size()):
		var slot_panel: Panel = slot_resource.instantiate()
		var slot_sprite: Sprite2D = slot_panel.get_child(0)
		slot_sprite.frame_coords = tool_to_atlas_coords(all_tools[i])
		slot_sprites[i] = slot_sprite
		if i == 0:
			self.add_child(slot_panel)
		else:
			slots.add_child(slot_panel)

func _process(_delta):
	if Input.is_action_just_pressed("Restart"):
		_on_restart_button_pressed()
		return
	
	if not slots.visible:
		return
	
	if Input.is_action_just_pressed("Mouse.Left"):
		for i in range(0, slot_sprites.size() - 1):
			var slot_sprite: Sprite2D = slot_sprites[i]
			var offset: Vector2 = slot_sprite.get_local_mouse_position()
			if slot_sprite.frame_coords != Vector2i(0, 2) and offset.x >= 0 and offset.x < slot_sprite_size and offset.y >= 0 and offset.y < slot_sprite_size:
				mouse_held_sprite_original_global_pos = slot_sprite.global_position
				mouse_held_sprite_index = i
				mouse_held_sprite = slot_sprite
				break
	
	if Input.is_action_just_released("Mouse.Left"):
		if mouse_held_sprite_index == -1:
			return
		for i in range(0, slot_sprites.size() - 1):
			if i == mouse_held_sprite_index:
				continue
			var slot_sprite: Sprite2D = slot_sprites[i]
			var offset: Vector2 = slot_sprite.get_local_mouse_position()
			mouse_held_sprite.global_position = mouse_held_sprite_original_global_pos
			if slot_sprite.frame_coords == Vector2i(0, 2) and offset.x >= 0 and offset.x < slot_sprite_size and offset.y >= 0 and offset.y < slot_sprite_size:
				var mouse_held_sprite_frame_coords: Vector2i = slot_sprite.frame_coords
				slot_sprite.frame_coords = mouse_held_sprite.frame_coords
				mouse_held_sprite.frame_coords = mouse_held_sprite_frame_coords
				drag_and_drop_done.emit(mouse_held_sprite_index, i)
				break
		mouse_held_sprite_index = -1
		mouse_held_sprite = null
	
	if mouse_held_sprite_index == -1:
		return
	mouse_held_sprite.global_position = get_canvas_transform().affine_inverse() * get_viewport().get_mouse_position()

func tool_to_atlas_coords(tool: Level.Tool) -> Vector2i:
	if tool == Level.Tool.KEY:
		return Vector2i(3, 0)
	if tool == Level.Tool.ARMOR:
		return Vector2i(3, 1)
	if tool == Level.Tool.HOVER:
		return Vector2i(3, 2)
	if tool == Level.Tool.PULL:
		return Vector2i(3, 3)
	return Vector2i(0, 2)

func _on_level_inventory_interaction(player_pos: Vector2, inventory_pos: Vector2, direction_from_player: Vector2):
	slots.visible = not slots.visible
	if slots.visible:
		var cell_size: float = slot_sprite_size * 3
		if direction_from_player == Vector2.LEFT:
			slot_sprites[0].get_parent().global_position = player_pos + Vector2(-cell_size / 2, cell_size / 2)
			var x_offset: float = -cell_size * (slot_sprites.size() - 3)
			for i in range(1, slot_sprites.size() - 1):
				slot_sprites[i].get_parent().global_position = inventory_pos + Vector2(x_offset - cell_size / 2, -cell_size * 3/2)
				x_offset += cell_size
		elif direction_from_player == Vector2.DOWN:
			slot_sprites[0].get_parent().global_position = player_pos + Vector2(-cell_size / 2, -cell_size * 3/2)
			var x_offset: float = 0.0
			for i in range(1, slot_sprites.size() - 1):
				slot_sprites[i].get_parent().global_position = inventory_pos + Vector2(x_offset - cell_size / 2, cell_size / 2)
				x_offset += cell_size
		else:
			slot_sprites[0].get_parent().global_position = player_pos + Vector2(-cell_size / 2, cell_size / 2)
			var x_offset: float = 0.0
			for i in range(1, slot_sprites.size() - 1):
				slot_sprites[i].get_parent().global_position = inventory_pos + Vector2(x_offset - cell_size / 2, -cell_size * 3/2)
				x_offset += cell_size

func _on_level_player_moved(player_pos: Vector2, inventory_below: bool):
	if inventory_below:
		var cell_size: float = slot_sprite_size * 3
		slot_sprites[0].get_parent().global_position = player_pos + Vector2(-cell_size / 2, -cell_size * 3/2)
	else:
		slot_sprites[0].get_parent().global_position = player_pos + Vector2(-1, 1) * slot_sprite_size * 3/2

func _on_level_level_finished():
	next_button.visible = true

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
