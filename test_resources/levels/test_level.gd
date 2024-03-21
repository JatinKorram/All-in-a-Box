extends Node2D
class_name TestLevel

signal player_moved(player_pos: Vector2)
signal level_finished()
signal level_failed()

func _setup(_level_contents: Node2D, ui_contents: Control):
	ui_contents.connect("drag_and_drop_done", _on_ui_drag_and_drop_done)

func _on_ui_drag_and_drop_done(_from_slot: int, _to_slot: int):
	pass
