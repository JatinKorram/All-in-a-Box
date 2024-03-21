extends Area2D
class_name Draggable

var being_dragged: bool = false
var dragging_mouse_offset: Vector2 = Vector2.ZERO
var drag_begin_pos: Vector2 = Vector2.ZERO

signal drag_and_drop(begin_pos: Vector2, end_pos: Vector2)

func _input_event(viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT and not event.pressed:
			return
		being_dragged = true
		drag_begin_pos = viewport.get_mouse_position()
		dragging_mouse_offset = get_local_mouse_position()

func _process(_delta):
	if not being_dragged:
		return
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	global_position = mouse_position - dragging_mouse_offset
	if Input.is_action_just_released("test_mouse_button"):
		being_dragged = false
		drag_and_drop.emit(drag_begin_pos, mouse_position)
