extends Node2D

@export var rotation_speed: float = 3
@export var max_rotation_angle: float = 30
@export var min_rotation_angle: float = -30
@export var observation_time: float = .5
@export var moving_camera: bool = true

@onready var pivot: Node2D = $Pivot
@onready var ray_cast: RayCast2D = $RayCast

var tween: Tween

func _ready() -> void:
	if moving_camera:
		pivot.rotation_degrees = min_rotation_angle
	
		tween = create_tween().set_loops()
		tween.tween_property(pivot, 'rotation_degrees', max_rotation_angle, rotation_speed)
		tween.tween_interval(observation_time)
		tween.tween_property(pivot, 'rotation_degrees', min_rotation_angle, rotation_speed)
		tween.tween_interval(observation_time)

func _on_area_2d_body_entered(body: Node2D) -> void:
	ray_cast.target_position = (ray_cast.to_local(body.global_position) - ray_cast.position) * ray_cast.transform
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding() and ray_cast.get_collider() is Player:
		EventBus.captured.emit()
