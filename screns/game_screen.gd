extends Node2D

@onready var preview_camera: Camera2D = $PreviewCamera
@onready var player_camera: Camera2D = $Player/PlayerCamera
@onready var player: Player = $Player

const FINAL_PREVIEW_POSITION: float = 4860
const PREVIEW_DURATION: float = 7
const START_TIMER: float = 0.5

func _ready() -> void:
	preview_camera.make_current()
	await get_tree().create_timer(START_TIMER).timeout
	var tween := create_tween().set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(preview_camera, 'global_position:y', FINAL_PREVIEW_POSITION, PREVIEW_DURATION)
	await tween.finished
	player.locked = false
	player_camera.make_current()
	GameManager.new_run()
