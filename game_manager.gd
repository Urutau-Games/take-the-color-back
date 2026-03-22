extends Node

var game_shader: ShaderMaterial = preload("res://assets/greyscale_shader_material.tres")
var all_doors: Array[RoomDoor]

var current_run: GameRun

func _ready() -> void:
	EventBus.color_part_found.connect(_on_color_part_found)

func register_door(door: RoomDoor) -> void:
	all_doors.push_back(door)

func new_run() -> void:
	current_run = GameRun.new(all_doors)

func has_all_colors() -> bool:
	return current_run.found_colors.values().all(func (c): return c == 1)

func _on_color_part_found(color: Constants.MissingColor) -> void:
	current_run.found_colors[color] += Constants.RECOVERY_AMOUNT
	
	EventBus.amounts_updated.emit(current_run.found_colors)
	
	if current_run.found_colors[color] == Constants.MAX_COLOR_VALUE:
		game_shader.set_shader_parameter(Constants.color_to_shader_property[color], true)

class GameRun: 
	var found_colors: Dictionary[Constants.MissingColor, float]
	
	func _init(available_doors: Array[RoomDoor]) -> void:
		found_colors = {
			Constants.MissingColor.Red: 0,
			Constants.MissingColor.Green: 0,
			Constants.MissingColor.Blue: 0
		}
		
		_reset_doors(available_doors)
		_roll_doors(available_doors)

	func _reset_doors(available_doors: Array[RoomDoor]) -> void:
		for door in available_doors:
			door.holding_color = Constants.MissingColor.None

	func _roll_doors(available_doors: Array[RoomDoor]) -> void:
		var door_groups = available_doors.reduce(_group_doors, {})
		
		for group in (Constants.available_colors.size()):
			door_groups[group].shuffle()
			var color = Constants.available_colors[group]
			
			for part in Constants.PARTS_PER_COLOR:
				door_groups[group][part].holding_color = color

	func _group_doors(groups: Dictionary, door: RoomDoor) -> Dictionary:
		var normalized_floor := door.floor_number - 1
		@warning_ignore("integer_division")
		var group := normalized_floor / Constants.FLOORS_PER_GROUP
		
		if groups.has(group):
			groups[group].push_back(door)
		else:
			groups[group] = [door]
		
		return groups
