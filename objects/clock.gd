extends Control

@onready var time: Label = %Time

func _process(_delta: float) -> void:
	if GameManager.is_running():
		_show_time()
	
func _show_time() -> void:
	time.text = Utils.format_time(GameManager.current_run.run_time)
