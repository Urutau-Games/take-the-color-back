extends Node

@warning_ignore("unused_signal")
signal color_part_found(color: Constants.MissingColor)

@warning_ignore("unused_signal")
signal amounts_updated(new_amounts: Dictionary[Constants.MissingColor, float])
