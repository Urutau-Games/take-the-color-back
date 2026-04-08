extends Object
class_name Constants

enum MissingColor { None, Red, Green, Blue}

const available_colors: Array[MissingColor] = [
	MissingColor.Red,
	MissingColor.Green,
	MissingColor.Blue
]

const color_to_shader_property: Dictionary[MissingColor, String] = {
	Constants.MissingColor.Red: "has_red",
	Constants.MissingColor.Green: "has_green",
	Constants.MissingColor.Blue: "has_blue"
}

const MAX_COLOR_VALUE: float = 1.0

const FLOORS_PER_GROUP: int = 4
const PARTS_PER_COLOR: float = 4

const RECOVERY_AMOUNT: float = 0.25

const CLOCK_TEMPLATE = "%02d:%02d"
const LEADERBOARD_NAME: String = "time-leaderboard"

const MUSIC_VOLUME_KEY: String = "Music"
const DEFAULT_AUDIO_SETTINGS: Dictionary[String, float] = {
	Constants.MUSIC_VOLUME_KEY: 1
}
