extends HBoxContainer

@onready var slider: HSlider = $Slider

func _ready() -> void:
	slider.value = AudioManager.current[Constants.MUSIC_VOLUME_KEY]


func _on_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioManager.current = {
			Constants.MUSIC_VOLUME_KEY: slider.value,
		}
		
		AudioManager.save_settings()
