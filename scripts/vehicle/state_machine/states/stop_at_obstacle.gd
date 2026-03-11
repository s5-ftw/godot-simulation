## Stops 30mm away from an obstacle based on the value read from the distance sensor.
## Knowing the time difference between polling is crucial for this application, as its
## the only way to know the vehicle's speed.
class_name StopAtObstacleState
extends VehicleState

var following: LineFollowing
var stopping: Stopping
var throttle: float = 0

func setup() -> void:
	self.stopping = Stopping.new(self.manager.adapters)
	self.following = LineFollowing.new(self.manager.adapters)
	throttle = 0

## Follows the line unless something is detected
func execute(delta):
	self.stopping.update(delta)
	self.following.execute(delta)
	
	## You dingus lost the line... That's more important than the obstacle.
	if self.following.lost_it():
		self.manager.set_state(DoNothingState) ## TODO: Call find line state
		return
	
	if !self.stopping.is_ready:
		return
	
	## Actively need to slow down to stop at the obstacle.
	self.manager.adapters.driving.set_driving(0)

	## Ok collision avoided... Just gotta stop at the obstacle now.
	if self.stopping.no_worries():
		throttle = move_toward(throttle, 1, delta * 0.5)
		self.manager.adapters.driving.set_driving(throttle)
		return
	else:
		throttle = 0
	
	## You're within safety margin of the obstacle. Try to avoid it now.
	if self.stopping.impossible_to_move():
		self.manager.set_state(DodgeobstacleState) ## TODO: Call avoid obstacle.
		return

## Returns the name of the current state.
func get_name() -> String:
	return "stop_at_obstacle"
