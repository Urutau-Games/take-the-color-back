extends Node2D

@export var rotation_speed: float = 3
@export var max_rotation_angle: float = 30
@export var observation_time: float = .5

@onready var pivot: Node2D = $Pivot
@onready var raycast: RayCast2D = $Raycast

var tween: Tween

func _ready() -> void:
	var rotation_points = [-max_rotation_angle, max_rotation_angle]
	
	rotation_points.shuffle()
	
	tween = create_tween().set_loops()
	tween.tween_property(pivot, 'rotation_degrees', rotation_points[0], rotation_speed)
	tween.tween_interval(observation_time)
	tween.tween_property(pivot, 'rotation_degrees', rotation_points[1], rotation_speed)
	tween.tween_interval(observation_time)

func _on_area_2d_body_entered(body: Node2D) -> void:
	raycast.target_position = to_local(body.global_position) - raycast.position
	raycast.force_raycast_update()
	
	if raycast.is_colliding() and raycast.get_collider() is Player:
		print("You're spotted")
	else:
		print("object")
