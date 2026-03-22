extends Node

@warning_ignore("unused_signal")
signal color_part_found(color: Constants.MissingColor)

@warning_ignore("unused_signal")
signal amounts_updated(new_amounts: Dictionary[Constants.MissingColor, float])

@warning_ignore("unused_signal")
signal game_started()

@warning_ignore("unused_signal")
signal captured()

@warning_ignore("unused_signal")
signal escaped()

@warning_ignore("unused_signal")
signal finished()
