extends GeneratedTile
class_name Flag

func _ready():
	area_entered.connect(_on_flag_area_entered)

func _on_flag_area_entered(_area: Area2D):
	Game.instance.load_level(Game.instance.level_system.current_level_index + 1)
