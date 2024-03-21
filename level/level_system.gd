extends Node2D
class_name LevelSystem

@export var levels: Array[LevelInfo]

var current_level_index: int = -1
var current_contents: Node2D = null

func load_level(level_index: int) -> bool:
	if level_index < 0 or level_index >= levels.size():
		print_debug("[LV] Load request receieved for out of bounds index: ", level_index)
		return false
	_load_contents(level_index)
	var ui_contents = Game.instance.ui_system._load_contents(levels[level_index].ui_mode)
	current_contents._setup(ui_contents)
	ui_contents._setup(current_contents)
	return true

func _load_contents(level_index: int) -> Node2D:
	if current_level_index != -1:
		current_contents.queue_free()
	current_contents = levels[level_index].scene.instantiate()
	add_child(current_contents)
	current_level_index = level_index
	return current_contents

func _process(_delta):
	if Input.is_action_just_pressed("test_prev_scene"):
		load_level(current_level_index - 1)
	if Input.is_action_just_pressed("test_next_scene"):
		load_level(current_level_index + 1)
