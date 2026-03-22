extends CharacterBody2D
class_name Player

@export var standup_speed: float = 300
@export var hidden_modulation: float = 0.3

@onready var standup_collision: CollisionShape2D = $StandupCollision
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite
@onready var message_label: Label = %MessageLabel

const MISSING: String = "I'm still missing colors!"
const FOUND: Array[String] = ["Got it!", "Nice!", "Yeah!"]
const EMPTY: Array[String] = ["Nope!", "Nothing here", "S****!"]

var locked: bool = true

var _is_hidden: bool = false
var _current_door: RoomDoor = null

func _ready() -> void:
	message_label.modulate.a = 0
	standup_collision.disabled = false


func _physics_process(_delta: float) -> void:
	if not locked and not _is_hidden:
		var direction = Input.get_axis("move_left", "move_right")
		
		if direction == 0:
			animation_player.play("idle")
		else:
			animation_player.play("walk")
			sprite.flip_h = direction < 0
		
		velocity.x = direction * standup_speed
		move_and_slide()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_hide") and not event.is_echo() and _current_door:
		animation_player.play("idle")
		_is_hidden = not _is_hidden
		
		if _is_hidden and not _current_door.checked:
			if _current_door.holding_color == Constants.MissingColor.None:
				_show_text(EMPTY.pick_random())
				_current_door.set_empty()
			else:
				EventBus.color_part_found.emit(_current_door.holding_color)
				_show_text(FOUND.pick_random())
				_current_door.set_robbed()
		
		standup_collision.disabled = _is_hidden
		modulate.a = hidden_modulation if _is_hidden else 1.0


func _on_room_door_detector_area_entered(area: Area2D) -> void:
	if area is RoomDoor:
		_current_door = area as RoomDoor
	elif area.name == 'ExitDoor':
		if GameManager.has_all_colors():
			EventBus.escaped.emit()
		else:
			_show_text(MISSING)


func _show_text(text: String) -> void:
	message_label.text = text
	var tween := create_tween()
	tween.tween_property(message_label, "modulate:a", 1, .25)
	tween.tween_interval(.75)
	tween.tween_property(message_label, "modulate:a", 0, .25)

func _on_room_door_detector_area_exited(_area: Area2D) -> void:
	_current_door = null
