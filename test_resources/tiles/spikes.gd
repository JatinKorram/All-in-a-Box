extends GeneratedTile
class_name Spikes

func _ready():
	connect("area_entered", _on_spikes_area_entered)

func _on_spikes_area_entered(_area: Area2D):
	(Game.get_ui_contents() as UIScreenSet).switch_to_screen(0)
