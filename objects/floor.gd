extends Node

@export var floor_number: int = 0

func _ready() -> void:
	for child in get_children():
		if child is RoomDoor:
			child.floor_number = floor_number
