## A state that avoids obstacle
class_name DodgeObsticalState
extends VehicleState

var dodge := ObstacleDodge.new()
var dodge_state = "idle"

func execute(delta):
	match dodge_state:
		"idle":
			if(dodge.execute_idle(delta, self.manager.adapters)):
				dodge_state = "turning_right"
		"turning_right":
			if(dodge.execute_turning_right(delta, self.manager.adapters)):
				dodge_state = "going_forward"
		"going_forward":
			if(dodge.execute_going_forward(delta, self.manager.adapters)):
				dodge_state = "returning"
		"returning":
			if(dodge.execute_returning(delta, self.manager.adapters)):
				dodge_state = "finished"
		"finished":
			dodge_state = "idle"
			self.manager.set_state(FollowLineState)

## Returns the name of the current state.
func get_name() -> String:
	return "dodge_obstical"
