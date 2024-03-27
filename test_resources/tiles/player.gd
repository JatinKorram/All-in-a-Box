extends GeneratedTile
class_name Player

@onready var world: World = Game.get_current_level_content()
@onready var interactor: GridBasedInteractor = GridBasedInteractor.new()

func _enter_tree():
	connect("destroyed", _on_player_destroyed)

func _on_player_destroyed():
	(Game.get_current_level_systems().get_child(0) as LevelStates).player_count -= 1

func _ready():
	(Game.get_current_level_systems().get_child(0) as LevelStates).player_count += 1
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
	world.push_cell(grid_position, direction)
