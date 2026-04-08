extends Control


func _on_menu_pressed() -> void:
	EventBus.finished.emit()
