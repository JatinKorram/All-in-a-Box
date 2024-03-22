extends Control
class_name TestUI

signal drag_and_drop_done(from_slot: int, to_slot: int)

func _setup():
	var level_contents: Node2D = Game.get_level_contents()
	level_contents.connect("player_moved", _on_player_moved)
	level_contents.connect("level_finished", _on_level_finished)
	level_contents.connect("level_failed", _on_level_failed)

func _on_player_moved(player_pos: Vector2):
	print_debug(player_pos)

func _on_level_finished():
	pass

func _on_level_failed():
	pass
