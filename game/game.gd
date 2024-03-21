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

func _ready():
	level_system.load_level(0)
