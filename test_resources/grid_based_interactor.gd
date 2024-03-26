extends Area2D
class_name GridBasedInteractor

@export_flags_2d_physics var interactable_layers: int = 0

@onready var world: World = Game.get_current_level_content()
@onready var collision_shape: CollisionShape2D = CollisionShape2D.new()

var interact_mode: bool = false

func _enter_tree():
	visible = false
	monitorable = false

func _ready():
	collision_mask = interactable_layers
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2.ONE * (world.cell_size - world.generated_colliders_padding)
	collision_shape.position = Vector2.ONE * world.cell_size / 2
	collision_shape.shape = shape
	add_child(collision_shape)
	var cursor_sprite: Sprite2D = Sprite2D.new()
	cursor_sprite.centered = false
	cursor_sprite.texture = preload("res://test_resources/interaction_cursor.png")
	cursor_sprite.z_index = 1
	add_child(cursor_sprite)

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		if interact_mode:
			var interactables: Array[Area2D] = get_overlapping_areas()
			if interactables.size() != 0:
				interactables[0].interaction.emit()
			position = Vector2.ZERO
			Game.get_current_ui_screens().disable_current_screen()
		else:
			Game.get_current_ui_screens().switch_to_screen(1)
		interact_mode = !interact_mode
		visible = interact_mode
	if not interact_mode:
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
	position = Vector2(direction) * world.cell_size
