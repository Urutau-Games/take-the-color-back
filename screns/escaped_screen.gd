extends Control

@onready var player_name: LineEdit = %PlayerName
@onready var submit_button: Button = %SubmitButton
@onready var time: Label = %Time
@onready var submit_region: HBoxContainer = $MarginContainer/VBoxContainer/SubmitRegion
@onready var message_area: Label = %MessageArea

func _ready() -> void:
	player_name.grab_focus()
	time.text = Utils.format_time(GameManager.current_run.run_time)

func _on_play_pressed() -> void:
	EventBus.game_started.emit()

func _on_menu_pressed() -> void:
	EventBus.finished.emit()


func _on_submit_pressed() -> void:
	message_area.show()
	submit_region.hide()
	var final_time = GameManager.current_run.run_time
	
	await Talo.players.identify("username", player_name.text)
	var entry = await Talo.leaderboards.add_entry(Constants.LEADERBOARD_NAME, final_time)
	
	message_area.text = "Sending..."
	
	if entry:
		message_area.text = "Score sent!"
	else:
		submit_region.show()
		message_area.text = "Fail to send. Please, try again"
