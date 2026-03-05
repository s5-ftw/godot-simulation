## Basic adapter implementing noise levels from config file.
## No cone view implementations or anything
class_name SimulatedDistanceSensor
extends DistanceSensorAdapter

## Keeps track of the polling interval to avoid making the user think he can poll really fast.
var next_ready_time: float = 0.0

## Follows precision time set in config
## @returns centimeters
func read() -> float:
	var now = Time.get_ticks_msec() / 1000.0  # Current time in seconds
	# If poll_interval is 0, always ready
	if self.config.poll_interval == 0 or now >= next_ready_time:
		# Set the next allowed read time
		next_ready_time = now + self.config.poll_interval
		return self.config.min_distance
	else:
		# Not ready, return 0 or some default
		return 0.0

func is_ready() -> bool:
	if self.config.poll_interval == 0:
		return true
	var now = Time.get_ticks_msec() / 1000.0
	return now >= next_ready_time
