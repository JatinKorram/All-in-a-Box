extends Area2D
class_name Player

@onready var level: Level = Game.get_level_contents()
@onready var grid_position: Vector2i = position / level.cell_size

func _process(_delta):
	var direction: Vector2i = Vector2i.ZERO
	if Input.is_action_just_pressed("move_up"):
		direction = Vector2i.UP
	if Input.is_action_just_pressed("move_down"):
		direction = Vector2i.DOWN
	if Input.is_action_just_pressed("move_left"):
		direction = Vector2i.LEFT
	if Input.is_action_just_pressed("move_right"):
		direction = Vector2i.RIGHT
	if direction == Vector2i.ZERO:
		return
	if level.push_cell(grid_position, direction):
		grid_position += direction
