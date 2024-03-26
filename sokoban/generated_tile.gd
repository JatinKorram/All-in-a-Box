extends Area2D
class_name GeneratedTile

var grid_position: Vector2i = Vector2.ZERO

func move(direction: Vector2i):
	grid_position += direction
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(grid_position) * Game.get_current_level_content().cell_size, 0.1)
