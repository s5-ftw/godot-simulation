## Follows the line around. If it stops detecting the line, it goes to a state that tries to find it.
## if it detects a wall, it goes to stop at obstacle. Simple stuff.
class_name FollowLineState
extends VehicleState

var stopping: Stopping
var following: LineFollowing

func setup() -> void:
	self.stopping = Stopping.new(self.manager.adapters)
	self.following = LineFollowing.new(self.manager.adapters)

## Follows the line unless something is detected
func execute(delta):
	stopping.update(delta)
	following.execute(delta)

	if stopping.will_collide() and stopping.is_ready:
		self.manager.set_state(StopAtObstacleState)
		return

	## We lost the line... gotta try to find it back.
	if following.lost_it():
		self.manager.set_state(DoNothingState) ## TODO: Replace with find line state.

## Returns the name of the current state.
func get_name() -> String:
	return "follow_line"
