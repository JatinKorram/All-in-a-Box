extends Area2D
class_name Flag

func _ready():
	area_entered.connect(_on_flag_area_entered)

func _on_flag_area_entered(_area: Area2D):
	print_debug("Flag entered!")
