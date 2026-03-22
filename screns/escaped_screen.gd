extends Control


func _on_play_pressed() -> void:
	EventBus.game_started.emit()


func _on_menu_pressed() -> void:
	EventBus.finished.emit()
