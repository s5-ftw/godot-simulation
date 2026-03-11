## A state that does nothing
## Serving as a placeholder when no states were made
class_name DoNothingState
extends VehicleState

var following: LineFollowing

func setup() -> void:
	self.following = LineFollowing.new(self.manager.adapters)
	
## Does nothing at all, except if line found
func execute(delta):
	if(!following.lost_it()):
		self.manager.set_state(FollowLineState)
	return

## Returns the name of the current state.
func get_name() -> String:
	return "do_nothing"
