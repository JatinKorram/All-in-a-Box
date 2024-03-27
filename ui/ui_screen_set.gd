extends Control
class_name UIScreenSet

var current_screen: UIScreen = null
var screen_count: int = 0

func _enter_tree():
	Game.connect_signal("ui_setup", _setup)

func _setup():
	screen_count = get_child_count()
	if screen_count == 0:
		return
	for screen: UIScreen in get_children():
		screen.disabled.emit()
		screen.set_process(false)

func disable_current_screen() -> bool:
	if current_screen == null:
		return false
	current_screen.disabled.emit()
	current_screen.set_process(false)
	current_screen = null
	return true

func switch_to_screen(screen_index: int) -> bool:
	disable_current_screen()
	if screen_index < 0 or screen_index >= screen_count:
		print_debug("[UISS] Switch request recieved for out of bounds index: ", screen_index)
		return false
	var screen: UIScreen = get_child(screen_index) as UIScreen
	current_screen = screen
	screen.set_process(true)
	screen.enabled.emit()
	return true
