extends GeneratedTile
class_name Flag

func _ready():
	area_entered.connect(_on_flag_area_entered)

func _on_flag_area_entered(_area: Area2D):
	Game.load_level(Game.get_current_level_index() + 1)
