extends Node2D
class_name LevelStates

enum Item {
	NONE = 0,
	KEY = 1,
	ARMOR = 2,
	HOVER = 3,
}

var player_count: int = 0

func _process(_delta):
	if player_count == 0:
		Game.get_current_ui_screens().switch_to_screen(0)
