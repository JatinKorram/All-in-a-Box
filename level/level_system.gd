extends Node2D
class_name LevelSystem

@export var levels: Array[LevelInfo]

var current_level_index: int = -1
var current_contents: Node2D = null

func _enter_tree():
	if levels.size() == 0:
		print_debug("[LV] No levels have been added.")

func _load_contents(level_index: int) -> Node2D:
	if level_index < 0 or level_index >= levels.size():
		print_debug("[LV] Load request receieved for out of bounds index: ", level_index)
		return null
	if current_level_index != -1:
		current_contents.queue_free()
	current_contents = levels[level_index].scene.instantiate()
	add_child(current_contents)
	current_level_index = level_index
	return current_contents
