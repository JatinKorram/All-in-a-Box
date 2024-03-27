extends GeneratedTile
class_name Hole

func _enter_tree():
	connect("area_entered", _on_hole_area_entered)

func _on_hole_area_entered(area: Area2D):
	(area as GeneratedTile).destroy()
