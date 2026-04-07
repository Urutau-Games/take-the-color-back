extends Node

var game_shader: ShaderMaterial = preload("res://assets/greyscale_shader_material.tres")

var current_run: GameRun

func _ready() -> void:
	EventBus.color_part_found.connect(_on_color_part_found)
	
	EventBus.captured.connect(_on_captured)
	EventBus.escaped.connect(_on_escaped)
	EventBus.finished.connect(_on_finished)

func new_run() -> void:
	var all_doors: Array[RoomDoor] = []
	get_tree().call_group('doors', 'register_self', all_doors)
	current_run = GameRun.new(all_doors)

func has_all_colors() -> bool:
	return current_run.found_colors.values().all(func (c): return c == 1)

func is_running() -> bool:
	return current_run and current_run.is_active

func _on_color_part_found(color: Constants.MissingColor) -> void:
	current_run.found_colors[color] += Constants.RECOVERY_AMOUNT
	
	EventBus.amounts_updated.emit(current_run.found_colors)
	
	if current_run.found_colors[color] == Constants.MAX_COLOR_VALUE:
		game_shader.set_shader_parameter(Constants.color_to_shader_property[color], true)

func _on_captured() -> void:
	_deactivate_run_if_active()

func _on_escaped() -> void:
	_deactivate_run_if_active()
	
func _on_finished() -> void:
	_deactivate_run_if_active()

func _deactivate_run_if_active() -> void:
	if is_running():
		current_run.is_active = false

func _process(delta: float) -> void:
	if is_running():
		current_run.run_time += delta

class GameRun: 
	var found_colors: Dictionary[Constants.MissingColor, float]
	var run_time: float
	var is_active: bool
	
	func _init(available_doors: Array[RoomDoor]) -> void:
		found_colors = {
			Constants.MissingColor.Red: 0,
			Constants.MissingColor.Green: 0,
			Constants.MissingColor.Blue: 0
		}
		
		run_time = 0
		
		_reset_doors(available_doors)
		_roll_doors(available_doors)
		
		is_active = true

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
