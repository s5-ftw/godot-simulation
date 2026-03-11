## This state awaits the line sensor conditions where they are all ON
## when that's the case, it drives until its no longer the case, then
## switches to the line following state.
class_name StartState
extends VehicleState

var first_time: bool = false
var driving: bool = false

## Awaits a line sensor related start line.
func execute(delta):
	var line = self.manager.adapters.line_sensor.read()
	var on_start_line = all_sensors_on(line)
	
	if on_start_line and self.manager.adapters.driving.get_current() == 0:
		self.manager.adapters.driving.set_driving(1)
		driving = true
	
	## Stopped detecting the start line. Regular operation can start
	if !on_start_line and driving:
		self.manager.set_state(FollowLineState)
	return

func all_sensors_on(sensor: int) -> bool:
	return sensor > 0 and (sensor & (sensor + 1)) == 0

## Returns the name of the current state.
func get_name() -> String:
	return "start"
