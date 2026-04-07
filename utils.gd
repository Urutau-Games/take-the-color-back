extends Object
class_name Utils

static func format_time(time_in_seconds: float) -> String:
	var minutes: float = time_in_seconds / 60
	var seconds: float = fmod(time_in_seconds, 60)
	
	return Constants.CLOCK_TEMPLATE % [minutes, seconds]
	
