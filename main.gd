extends SubViewportContainer

@export var title_screen: PackedScene
@export var game_screen: PackedScene
@export var game_over_screen: PackedScene
@export var win_screen: PackedScene
@export var leaderboard_screen: PackedScene
@export var credits_screen: PackedScene


@onready var game_music_player: AudioStreamPlayer = $GameMusicPlayer
@onready var menu_music_player: AudioStreamPlayer = $MenuMusicPlayer
@onready var container: SubViewport = $Container

func _ready() -> void:
	_play_menu()
	
	EventBus.game_started.connect(_on_game_started)
	EventBus.captured.connect(_on_captured)
	EventBus.finished.connect(_on_finished)
	EventBus.escaped.connect(_on_escaped)
	EventBus.leaderboard_accessed.connect(_on_leaderboard_accessed)
	EventBus.credits_accessed.connect(_on_credits_accessed)
	
	container.add_child(title_screen.instantiate())


func _on_game_started() -> void:
	_play_game()
	container.get_child(0).queue_free()
	container.add_child.call_deferred(game_screen.instantiate())


func _on_captured() -> void:
	container.get_child(0).queue_free()
	container.add_child.call_deferred(game_over_screen.instantiate())


func _on_finished() -> void:
	_play_menu()
	container.get_child(0).queue_free()
	container.add_child.call_deferred(title_screen.instantiate())
	

func _on_leaderboard_accessed() -> void:
	container.get_child(0).queue_free()
	container.add_child.call_deferred(leaderboard_screen.instantiate())
	
	
func _on_credits_accessed() -> void:
	container.get_child(0).queue_free()
	container.add_child.call_deferred(credits_screen.instantiate())


func _on_escaped() -> void:
	container.get_child(0).queue_free()
	container.add_child.call_deferred(win_screen.instantiate())


func _play_menu() -> void:
	if not menu_music_player.playing:
		game_music_player.stop()
		menu_music_player.play()
	

func _play_game() -> void:
	if not game_music_player.playing:
		menu_music_player.stop()
		game_music_player.play()
