extends Node2D
class_name TestLevel

signal player_moved(player_pos: Vector2)
signal level_finished()
signal level_failed()

func _setup(ui_contents: Control):
	ui_contents.connect("drag_and_drop_done", _on_ui_drag_and_drop_done)

func _process(_delta):
	if Input.is_action_just_pressed("test_move_up"):
		player_moved.emit(Vector2.ZERO)

func _on_ui_drag_and_drop_done(_from_slot: int, _to_slot: int):
	pass
