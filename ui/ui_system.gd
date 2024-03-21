extends Control
class_name UISystem

enum UIMode
{
	MENU = 0,
	LEVEL = 1,
}

@export var mode_contents: Array[PackedScene]

var current_mode: int = -1
var current_contents: Control = null

func _enter_tree():
	if mode_contents.size() != UIMode.size():
		print_debug("[UI] The number of UI scenes added is not equal to the number of UI modes!")

func _load_contents(mode: UIMode) -> Control:
	if mode == current_mode:
		return current_contents
	if current_mode != -1:
		current_contents.queue_free()
	current_contents = mode_contents[mode].instantiate()
	add_child(current_contents)
	current_mode = mode
	return current_contents
