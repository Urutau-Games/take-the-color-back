extends Area2D
class_name RoomDoor

@export var unknown_texture: Texture2D
@export var robbed_texture: Texture2D
@export var empty_texture: Texture2D

@onready var door_sprite: Sprite2D = $DoorSprite

var floor_number: int
var holding_color: Constants.MissingColor = Constants.MissingColor.None
var checked: bool = false

func _ready() -> void:
	door_sprite.texture = unknown_texture

func register_self(container: Array[RoomDoor]) -> void:
	container.push_back(self)

func set_robbed() -> void:
	holding_color = Constants.MissingColor.None
	door_sprite.texture = robbed_texture
	checked = true
	
func set_empty() -> void:
	door_sprite.texture = empty_texture
	checked = true
