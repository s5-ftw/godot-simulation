## Tries to find back the line you just lost. Probably steered too fast in a corner or some shit.
class_name FindLineState
extends VehicleState

var previous_steering: float = 0

func setup() -> void:
	self.previous_steering = self.manager.adapters.steering.get_current()
	print(self.manager.adapters.steering.get_current())

## Follows the line unless something is detected
func execute(delta):
	self.manager.adapters.driving.set_driving(0.5)
	self.manager.adapters.steering.set_steering(sign(previous_steering))
	
	if self.manager.adapters.line_sensor.read() != 0:
		self.manager.set_state(FollowLineState)
	
## Returns the name of the current state.
func get_name() -> String:
	return "find_line"
