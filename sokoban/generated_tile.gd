extends Area2D
class_name GeneratedTile

var type_index: int = -1
var grid_position: Vector2i = Vector2i.ZERO

signal destroyed()

func move(direction: Vector2i):
	grid_position += direction
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(grid_position) * Game.get_current_level_content().cell_size, 0.1)

func destroy():
	(Game.get_current_level_content() as World)._destroy_cell(grid_position, monitoring)
