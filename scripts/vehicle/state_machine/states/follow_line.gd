## Follows the line around. If it stops detecting the line, it goes to a state that tries to find it.
## if it detects a wall, it goes to stop at obstacle. Simple stuff.
class_name FollowLineState
extends VehicleState

var stopping: Stopping
var following: LineFollowing
var previous_steering: float = 0

func setup() -> void:
	self.stopping = Stopping.new(self.manager.adapters)
	self.following = LineFollowing.new(self.manager.adapters)
	self.previous_steering = self.manager.adapters.steering.get_current()

## Follows the line unless something is detected
func execute(delta):
	self.stopping.update(delta)
	self.following.execute(delta)

	if self.stopping.will_collide() and self.stopping.is_ready:
		self.manager.set_state(StopAtObstacleState)
		return

	## We lost the line... gotta try to find it back.
	if self.following.lost_it():
		self.manager.set_state(FindLineState)

## Returns the name of the current state.
func get_name() -> String:
	return "follow_line"
