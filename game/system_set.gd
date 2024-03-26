extends Node2D
class_name SystemSet

var system_count: int = 0

func _ready():
	system_count = get_child_count()

func enable_system(system_index: int) -> bool:
	if system_index < 0 or system_index >= system_count:
		print_debug("[SS] Enable request received for out of bounds index: ", system_index)
		return false
	get_child(system_index).set_process(true)
	return true

func disable_system(system_index: int) -> bool:
	if system_index < 0 or system_index >= system_count:
		print_debug("[SS] Disable request received for out of bounds index: ", system_index)
		return false
	get_child(system_index).set_process(false)
	return true
