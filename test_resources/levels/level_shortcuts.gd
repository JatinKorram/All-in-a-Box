extends Node2D
class_name LevelShortcuts

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		Game.load_level(Game.get_current_level_index())
