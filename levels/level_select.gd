extends Control
class_name LevelSelect

func _on_level_level_finished():
	visible = true

func _on_01_pressed():
	get_tree().change_scene_to_file("res://levels/level_01.tscn")

func _on_02_pressed():
	get_tree().change_scene_to_file("res://levels/level_02.tscn")

func _on_03_pressed():
	get_tree().change_scene_to_file("res://levels/level_03.tscn")

func _on_04_pressed():
	get_tree().change_scene_to_file("res://levels/level_04.tscn")

func _on_05_pressed():
	get_tree().change_scene_to_file("res://levels/level_05.tscn")

func _on_06_pressed():
	get_tree().change_scene_to_file("res://levels/level_06.tscn")

func _on_07_pressed():
	get_tree().change_scene_to_file("res://levels/level_07.tscn")

func _on_08_pressed():
	get_tree().change_scene_to_file("res://levels/level_08.tscn")

func _on_09_pressed():
	get_tree().change_scene_to_file("res://levels/level_09.tscn")

func _on_10_pressed():
	get_tree().change_scene_to_file("res://levels/level_10.tscn")
