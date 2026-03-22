extends Control
@onready var exit: Button = %Exit

func _ready() -> void:
	exit.visible = not OS.has_feature("web")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	EventBus.game_started.emit()
