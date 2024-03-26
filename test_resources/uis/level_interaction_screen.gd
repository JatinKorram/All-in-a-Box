extends UIScreen

func _enter_tree():
	connect("enabled", _on_enabled)
	connect("disabled", _on_disabled)

func _on_enabled():
	visible = true

func _on_disabled():
	visible = false
