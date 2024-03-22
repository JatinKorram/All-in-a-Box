extends Node2D
class_name Game

# Functions
# - Loading
# - Setting up

static var instance: Game = null

@export var level_system: LevelSystem
@export var ui_system: UISystem

signal level_setup()
signal ui_setup()

static func get_level_contents() -> Node2D:
	return instance.level_system.current_contents

static func get_ui_contents() -> Control:
	return instance.ui_system.current_contents

func _enter_tree():
	instance = self

func load_level(level_index: int) -> bool:
	var level_contents = level_system._load_contents(level_index)
	if level_contents == null:
		return false
	var ui_contents = ui_system._load_contents(level_system.levels[level_index].ui_mode)
	if ui_contents == null:
		return false
	level_setup.emit()
	ui_setup.emit()
	return true

func _ready():
	# NOTE: Change this back to 0 when done testing
	load_level(1)
