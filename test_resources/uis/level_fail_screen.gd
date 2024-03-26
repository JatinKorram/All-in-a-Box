extends UIScreen

func _enter_tree():
	connect("enabled", _on_enabled)
	connect("disabled", _on_disabled)

func _on_enabled():
	get_tree().paused = true
	visible = true

func _on_disabled():
	get_tree().paused = false
	visible = false
