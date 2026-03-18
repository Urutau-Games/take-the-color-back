extends CharacterBody2D
class_name Player

@export var standup_speed: float = 300
@export var crouch_speed: float = 100

@onready var standup_collision: CollisionShape2D = $StandupCollision
@onready var crouch_collision: CollisionShape2D = $CrouchCollision

var _is_up: bool = true

func _ready() -> void:
	standup_collision.disabled = not _is_up
	crouch_collision.disabled = _is_up
	
func _physics_process(_delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")
	
	velocity.x = direction * (standup_speed if _is_up else crouch_speed)
	
	move_and_slide() 

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_crouch") and not event.is_echo():
		_is_up = not _is_up
		standup_collision.disabled = not _is_up
		crouch_collision.disabled = _is_up
