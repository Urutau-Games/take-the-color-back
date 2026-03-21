extends Control

@onready var red_bar: ProgressBar = $PanelContainer/HBoxContainer/RedBar
@onready var green_bar: ProgressBar = $PanelContainer/HBoxContainer/GreenBar
@onready var blue_bar: ProgressBar = $PanelContainer/HBoxContainer/BlueBar

func _ready() -> void:
	EventBus.amounts_updated.connect(_on_amounts_updated)
	

func _on_amounts_updated(new_amounts: Dictionary[Constants.MissingColor, float]) -> void:
	red_bar.value = new_amounts[Constants.MissingColor.Red]
	green_bar.value = new_amounts[Constants.MissingColor.Green]
	blue_bar.value = new_amounts[Constants.MissingColor.Blue]
