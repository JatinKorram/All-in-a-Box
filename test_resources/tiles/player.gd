extends GeneratedTile
class_name Player

@onready var level: Level = Game.get_level_contents()
@onready var interactor: GridBasedInteractor = GridBasedInteractor.new()

func _ready():
	# NOTE: Testing
	interactor.interactable_layers = 4
	#
	add_child(interactor)

func _process(_delta):
	if interactor.interact_mode:
		return
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
	level.push_cell(grid_position, direction)
