extends Node2D
class_name Game

# Functions
# - Loading
# - Setting up

static var instance: Game = null

@export var level_system: LevelSystem
@export var ui_system: UISystem

func _enter_tree():
	instance = self

func load_level(level_index: int) -> bool:
	var level_contents = level_system._load_contents(level_index)
	if level_contents == null:
		return false
	var ui_contents = ui_system._load_contents(level_system.levels[level_index].ui_mode)
	if ui_contents == null:
		return false
	level_contents._setup(level_contents, ui_contents)
	ui_contents._setup(level_contents, ui_contents)
	return true

func _ready():
	load_level(0)
