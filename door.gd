extends Area2D
class_name RoomDoor

var floor_number: int

var holding_color: Constants.MissingColor = Constants.MissingColor.None

func _ready() -> void:
	GameManager.register_door(self)
