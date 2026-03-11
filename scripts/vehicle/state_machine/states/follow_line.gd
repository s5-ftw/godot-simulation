## Follows the line around. If it stops detecting the line, it goes to a state that tries to find it.
## if it detects a wall, it goes to stop at obstacle. Simple stuff.
class_name FollowLineState
extends VehicleState

## Follows the line unless something is detected
func execute(delta):
	LineFollowing.new().execute(delta, self.manager.adapters)
	
	var distance = self.manager.adapters.distance_sensor.read()
	## TODO: Calculate stopping distance for max acceleration.
	if distance < self.manager.adapters.distance_sensor.config.max_distance - 100:
		## Go stop at the obstacle
		self.manager.set_state(DodgeObsticalState) ## TODO: Replace with Stop at obstacle state
		
	if self.manager.adapters.line_sensor.read() == 0:
		## We lost the line... gotta try to find it back.
		self.manager.set_state(DoNothingState) ## TODO: Replace with find line state.

## Returns the name of the current state.
func get_name() -> String:
	return "follow_line"
