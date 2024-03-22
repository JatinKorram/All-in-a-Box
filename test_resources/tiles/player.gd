extends Area2D
class_name Player

@onready var level: Level = Game.get_level_contents()

func _process(_delta):
	var direction: Vector2 = Vector2.ZERO
	if Input.is_action_just_pressed("move_up"):
		direction = Vector2.UP
	if Input.is_action_just_pressed("move_down"):
		direction = Vector2.DOWN
	if Input.is_action_just_pressed("move_left"):
		direction = Vector2.LEFT
	if Input.is_action_just_pressed("move_right"):
		direction = Vector2.RIGHT
	if direction == Vector2.ZERO:
		return
	level.level_manipulator.push_cell(position / level.cell_size, Vector2i(direction))
