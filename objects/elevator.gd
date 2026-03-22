extends AnimatableBody2D

@export var highest_floor: int = 5
@export var lowest_floor: int = 1
@export var elevator_speed: int = 5

@export var disabled_light: Color
@export var enabled_light: Color

@onready var door: StaticBody2D = $Door
@onready var indicator_light: PointLight2D = $IndicatorLight

const floor_size: float = 430

var _is_player_safe: bool = false
var _is_moving: bool = false

var _current_floor: int = 1

var _initial_position: float = 0
var _target_position: float = 0

func _ready() -> void:
	_initial_position = global_position.y
	indicator_light.color = disabled_light
	door.process_mode = Node.PROCESS_MODE_DISABLED

func _on_safe_zone_body_entered(_body: Node2D) -> void:
	_is_player_safe = true
	indicator_light.color = enabled_light

func _on_safe_zone_body_exited(_body: Node2D) -> void:
	_is_player_safe = false
	indicator_light.color = disabled_light

func _physics_process(_delta: float) -> void:
	if not _is_player_safe or _is_moving:
		return
	
	var direction := Input.get_axis("elevator_up", "elevator_down")
	
	if direction != 0 and _can_move_to(direction):
		_lock_elevator()
		_move_to(direction)

func _can_move_to(direction: float):
	var can_go_up := direction < 0 and _current_floor < highest_floor
	var can_go_down := direction > 0 and _current_floor > lowest_floor
	return can_go_up or can_go_down

func _move_to(direction: float) -> void:
	@warning_ignore("narrowing_conversion")
	_current_floor -= direction
	_target_position = global_position.y + floor_size * direction

	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position:y", _target_position, 1)
	tween.tween_callback(_unlock_elevator)

func _lock_elevator() -> void:
	_is_moving = true
	door.process_mode = Node.PROCESS_MODE_INHERIT
	
func _unlock_elevator() -> void:
	_is_moving = false
	door.process_mode = Node.PROCESS_MODE_DISABLED
