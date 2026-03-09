## Basic adapter implementing noise levels from config file.
## No cone view implementations or anything
class_name SimulatedDistanceSensor
extends DistanceSensorAdapter

## Keeps track of the polling interval to avoid making you think you can poll really fast.
var next_ready_time: float = 0.0
var bound_node: Node = null
const SOUND_SPEED_CM_PER_SEC = 34300.0 # approx 343 m/s

## Follows precision time set in config
## @returns centimeters
func read() -> float:
	if bound_node == null:
		push_error("SimulatedDistanceSensor is not bound to a Node!")
		return 0.0

	var distance = 10 # TODO: HARDCODED. FIX.
	distance = _apply_precision_noise(distance)
	var time_to_wait = _calculate_await_time(distance)
	## AWAIT LOGIC SIMULATING BEING STUCK WAITING FOR SENSOR ECHO
	await bound_node.create_timer(time_to_wait).timeout
	
	var now = Time.get_ticks_msec() / 1000.0
	# You didn't wait for the poll interval to end. Your signal has higher chance to be noisy
	# because you might be detecting an old echo... Accept the limitations fam.
	if self.config.poll_interval != 0 and now < next_ready_time:
		return 0.0 # TODO: FIX

	# Next allowed read time
	next_ready_time = now + self.config.poll_interval
	return self.config.min_distance

func is_ready() -> bool:
	if self.config.poll_interval == 0:
		return true
	var now = Time.get_ticks_msec() / 1000.0
	return now >= next_ready_time
	
## If you're not threaded, everytime you TRIG, you wait x amount of ms
## for the echo to arrive. This dictate how long you'll wait based on the
## speed of sound.
func _calculate_await_time(distance_cm: float) -> float:
	# time = distance / speed * 2 (round trip)
	return (distance_cm / SOUND_SPEED_CM_PER_SEC) * 2.0

## Apply noises in a precision range to the ideal simulated distance.
func _apply_precision_noise(distance_cm: float) -> float:
	var noise = randf_range(-self.config.precision, self.config.precision)
	return distance_cm + noise
