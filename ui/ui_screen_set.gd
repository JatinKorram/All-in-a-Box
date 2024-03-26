extends Control
class_name UIScreenSet

var current_screen: UIScreen = null
var screen_count: int = 0

func _ready():
	screen_count = get_child_count()
	if screen_count == 0:
		print_debug("[UISS] No screens have been added.")
		return
	for screen: UIScreen in get_children():
		screen.set_process(false)

func disable_current_screen() -> bool:
	if current_screen == null:
		return false
	current_screen.disabled.emit()
	current_screen.set_process(false)
	current_screen = null
	return true

func switch_to_screen(index: int) -> bool:
	disable_current_screen()
	if index < 0 or index >= screen_count:
		print_debug("[UISS] Enable request recieved for out of bounds index: ", index)
		return false
	var screen: UIScreen = get_child(index) as UIScreen
	current_screen = screen
	screen.set_process(true)
	screen.enabled.emit()
	return true
