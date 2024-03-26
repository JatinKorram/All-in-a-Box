extends Control
class_name UILoader

enum UIMode
{
	MENU = 0,
	LEVEL = 1,
}

@export var mode_uis: Array[PackedScene]

var current_ui_mode: int = -1
var current_ui: UI = null

func _enter_tree():
	if mode_uis.size() != UIMode.size():
		print_debug("[UI] The number of UI scenes added is not equal to the number of UI modes!")

func _load_contents(ui_mode: UIMode) -> Control:
	if ui_mode == current_ui_mode:
		return current_ui
	if current_ui_mode != -1:
		current_ui.queue_free()
	current_ui = mode_uis[ui_mode].instantiate()
	add_child(current_ui)
	current_ui_mode = ui_mode
	return current_ui
