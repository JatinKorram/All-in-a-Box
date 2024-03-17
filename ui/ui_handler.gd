extends Control
class_name UIHandler

@export var slots: Control = null
@export var next_button: Button = null
@export var next_level_name: String = ""
@onready var fail_label: Label = $"FailLabel"
@onready var interaction_ui: Control = $"InteractionUI"
@onready var interaction_ui_keys: Control = $"InteractionUI/Keys"
@onready var interaction_ui_key_w: Sprite2D = $"InteractionUI/Keys/W"
@onready var interaction_ui_key_s: Sprite2D = $"InteractionUI/Keys/S"
@onready var interaction_ui_key_a: Sprite2D = $"InteractionUI/Keys/A"
@onready var interaction_ui_key_d: Sprite2D = $"InteractionUI/Keys/D"
@onready var interaction_popup: Control = $"InteractionPopup"

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
		var slot_panel: NinePatchRect = slot_resource.instantiate()
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
	interaction_popup.visible = not interaction_ui.visible and not slots.visible
	if slots.visible:
		var cell_size: float = slot_sprite_size * 3
		slot_sprites[0].get_parent().visible = true
		slot_sprites[0].get_parent().size = Vector2(20, 20)
		slot_sprites[0].scale = Vector2(1, 1)
		if direction_from_player == Vector2.LEFT:
			slot_sprites[0].get_parent().global_position = player_pos + Vector2(-cell_size / 2, cell_size / 2)
			var x_offset: float = -(cell_size + 12) * (slot_sprites.size() - 3)
			for i in range(1, slot_sprites.size() - 1):
				slot_sprites[i].get_parent().global_position = inventory_pos + Vector2(x_offset - cell_size / 2, -cell_size * 3/2)
				x_offset += cell_size + 12
		elif direction_from_player == Vector2.DOWN:
			slot_sprites[0].get_parent().global_position = player_pos + Vector2(-cell_size / 2, -cell_size * 3/2)
			var x_offset: float = 0.0
			for i in range(1, slot_sprites.size() - 1):
				slot_sprites[i].get_parent().global_position = inventory_pos + Vector2(x_offset - cell_size / 2, cell_size / 2)
				x_offset += cell_size + 12
		else:
			slot_sprites[0].get_parent().global_position = player_pos + Vector2(-cell_size / 2, cell_size / 2)
			var x_offset: float = 0.0
			for i in range(1, slot_sprites.size() - 1):
				slot_sprites[i].get_parent().global_position = inventory_pos + Vector2(x_offset - cell_size / 2, -cell_size * 3/2)
				x_offset += cell_size + 12
	else:
		slot_sprites[0].get_parent().visible = slot_sprites[0].frame_coords != Vector2i(0, 2)
		slot_sprites[0].get_parent().global_position = player_pos + Vector2.DOWN * 6
		slot_sprites[0].get_parent().size = Vector2(12, 12)
		slot_sprites[0].scale = Vector2(0.5, 0.5)

func _on_level_player_moved(player_pos: Vector2, _inventory_below: bool):
	slot_sprites[0].get_parent().visible = slot_sprites[0].frame_coords != Vector2i(0, 2)
	slot_sprites[0].get_parent().global_position = player_pos + Vector2.DOWN * 6
	slot_sprites[0].get_parent().size = Vector2(12, 12)
	slot_sprites[0].scale = Vector2(0.5, 0.5)

func _on_level_level_finished():
	next_button.visible = true

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_next_button_pressed():
	get_tree().change_scene_to_file("res://levels/" + next_level_name + ".tscn")

func _on_level_level_failed():
	fail_label.visible = true

func _on_level_interaction_choice_given(player_pos: Vector2, interaction_up: bool, interaction_down: bool, interaction_left: bool, interaction_right: bool):
	slot_sprites[0].get_parent().visible = interaction_ui.visible
	interaction_ui.visible = not interaction_ui.visible
	interaction_ui_key_w.visible = interaction_up
	interaction_ui_key_s.visible = interaction_down
	interaction_ui_key_a.visible = interaction_left
	interaction_ui_key_d.visible = interaction_right
	interaction_ui_keys.global_position = player_pos - Vector2.ONE * slot_sprite_size * 3/2

func _on_level_interaction_available(player_pos: Vector2, available: bool):
	interaction_popup.visible = available and not interaction_ui.visible and not slots.visible
	if interaction_popup.visible:
		interaction_popup.global_position = player_pos - Vector2.ONE * slot_sprite_size * 3/2

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
