extends CharacterBody2D
class_name Player

@export var standup_speed: float = 300
@export var crouch_speed: float = 100

@onready var standup_collision: CollisionShape2D = $StandupCollision
@onready var crouch_collision: CollisionShape2D = $CrouchCollision

var _is_up: bool = true
var _is_hidden: bool = false
var _current_door: RoomDoor = null

func _ready() -> void:
	standup_collision.disabled = not _is_up
	crouch_collision.disabled = _is_up
	
func _physics_process(_delta: float) -> void:
	if not _is_hidden:
		var direction = Input.get_axis("move_left", "move_right")
		velocity.x = direction * (standup_speed if _is_up else crouch_speed)
		move_and_slide()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_crouch") and not event.is_echo():
		_is_up = not _is_up

	if event.is_action_pressed("toggle_hide") and not event.is_echo() and _current_door:
		_is_hidden = not _is_hidden
		if _is_hidden and not _current_door.holding_color == Constants.MissingColor.None:
			EventBus.color_part_found.emit(_current_door.holding_color)
			_current_door.holding_color = Constants.MissingColor.None
		
	standup_collision.disabled = _is_hidden or not _is_up
	crouch_collision.disabled = _is_hidden or _is_up


func _on_room_door_detector_area_entered(area: Area2D) -> void:
	_current_door = area as RoomDoor


func _on_room_door_detector_area_exited(_area: Area2D) -> void:
	_current_door = null
