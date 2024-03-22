extends Node2D
class_name Level

@export var cell_size: int = 16

@onready var level_builder: LevelBuilder = $LevelBuilder
#@onready var level_manipulator: LevelManipulator = $TileMap

func _enter_tree():
	Game.instance.connect("level_setup", _setup)

func _setup():
	level_builder.build(level_manipulator, cell_size)
