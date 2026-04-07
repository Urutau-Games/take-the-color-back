extends Control

@export var leaderboard_entry: PackedScene
@onready var board: VBoxContainer = %Board
@onready var loading: Label = %Loading

func _ready() -> void:
	var options := Talo.leaderboards.GetEntriesOptions.new()
	options.page = 0
	var result := await Talo.leaderboards.get_entries(Constants.LEADERBOARD_NAME, options)
	var entries: Array[TaloLeaderboardEntry] = result.entries
	var top_ten = entries.slice(0, 10)
	
	loading.queue_free()
	
	for entry: TaloLeaderboardEntry in top_ten:
		var item = leaderboard_entry.instantiate()
		item.get_node("%Player").text = entry.player_alias.identifier
		item.get_node("%Time").text = Utils.format_time(entry.score)
		board.add_child(item)

func _on_menu_pressed() -> void:
	EventBus.finished.emit()
