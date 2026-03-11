## A state that does nothing
## Serving as a placeholder when no states were made
class_name DoNothingState
extends VehicleState

var following: LineFollowing
	
## Does nothing at all
func execute(delta):
	return

## Returns the name of the current state.
func get_name() -> String:
	return "do_nothing"
