extends SubViewportContainer

@export var title_screen: PackedScene
@export var game_screen: PackedScene
@export var game_over_screen: PackedScene
@export var win_screen: PackedScene

@onready var container: SubViewport = $Container

func _ready() -> void:
	EventBus.game_started.connect(_on_game_started)
	EventBus.captured.connect(_on_captured)
	EventBus.finished.connect(_on_finished)
	EventBus.escaped.connect(_on_escaped)
	
	container.add_child(title_screen.instantiate())


func _on_game_started() -> void:
	container.get_child(0).queue_free()
	container.add_child.call_deferred(game_screen.instantiate())


func _on_captured() -> void:
	container.get_child(0).queue_free()
	container.add_child.call_deferred(game_over_screen.instantiate())

func _on_finished() -> void:
	container.get_child(0).queue_free()
	container.add_child.call_deferred(title_screen.instantiate())
	
	
func _on_escaped() -> void:
	container.get_child(0).queue_free()
	container.add_child.call_deferred(win_screen.instantiate())
