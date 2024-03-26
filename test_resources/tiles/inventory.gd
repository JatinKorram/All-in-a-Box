extends InteractableTile
class_name Inventory

func _enter_tree():
	connect("interaction", _on_interaction)

func _on_interaction():
	print_debug("Interacted with Inventory!")
