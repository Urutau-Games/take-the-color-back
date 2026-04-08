extends CharacterBody2D

@export var rotation_speed: float = 2
@export var max_rotation_angle: float = 10
@export var observation_time: float = .5
@export var start_inverted: bool = false
@export var walk_speed: float = 200

@onready var pivot: Node2D = $Pivot
@onready var ray_cast: RayCast2D = $Pivot/Area2D/RayCast

@onready var movement_raycast: RayCast2D = $MovementRaycast

var _direction: Vector2 = Vector2.RIGHT
var _target: Player = null

func _ready() -> void:
	if start_inverted:
		_invert()
	
	_start_scan()

func _invert() -> void:
	_direction *= -1
	scale.x *= -1

func _process(_delta: float) -> void:
	velocity = _direction * walk_speed
	
	if movement_raycast.is_colliding():
		_invert()
	
	if _target:
		ray_cast.target_position = (ray_cast.to_local(_target.global_position) - ray_cast.position) * ray_cast.transform
		ray_cast.force_raycast_update()
		
		if ray_cast.is_colliding() and ray_cast.get_collider() is Player:
			EventBus.captured.emit()
	
	move_and_slide()

func _start_scan() -> void:
	var tween := create_tween().set_loops()
	tween.tween_property(pivot, 'rotation_degrees', max_rotation_angle, rotation_speed)
	tween.tween_interval(observation_time)
	tween.tween_property(pivot, 'rotation_degrees', -max_rotation_angle, rotation_speed)
	tween.tween_interval(observation_time)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		_target = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		_target = null
