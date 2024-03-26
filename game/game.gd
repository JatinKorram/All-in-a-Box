extends Node2D
class_name Game

# Functions
# - Loading
# - Setting up

static var instance: Game = null

@export var _level_loader: LevelLoader = null
@export var _ui_loader: UILoader = null
@export var _systems: SystemSet = null

signal level_loaded()

signal level_setup()
signal ui_setup()

static func get_current_level_contents() -> Node2D:
	return instance._level_loader.current_level.contents

static func get_current_level_systems() -> SystemSet:
	return instance._level_loader.current_level.systems

static func get_current_level_index() -> int:
	return instance._level_loader.current_level_index

static func get_current_ui_screens() -> UIScreenSet:
	return instance._ui_loader.current_ui.screens

static func get_current_ui_systems() -> SystemSet:
	return instance._ui_loader.current_ui.systems

static func get_current_ui_mode() -> int:
	return instance._ui_loader.current_ui_mode

static func get_systems() -> SystemSet:
	return instance._systems

static func load_level(level_index: int) -> bool:
	return instance._load_level(level_index)

func _enter_tree():
	instance = self

func _load_level(level_index: int) -> bool:
	var level_contents = _level_loader._load_contents(level_index)
	if level_contents == null:
		return false
	var ui_contents = _ui_loader._load_contents(_level_loader.levels[level_index].ui_mode)
	if ui_contents == null:
		return false
	level_setup.emit()
	ui_setup.emit()
	level_loaded.emit()
	return true

func _ready():
	_load_level(0)
