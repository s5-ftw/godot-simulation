## Abstract (interface) for a state of the vehicle.
##
## All individual states must extend this one.
class_name VehicleState
extends RefCounted

var manager: VehicleStateManager

func _init(
	manager: VehicleStateManager,
) -> void:
	self.manager = manager

## Execute the state. This essentially handles what the vehicle gotta do.
func execute():
	push_error("execute() must be implemented in the state")
	return

## Returns the name of the current state.
func get_name() -> String:
	push_error("get_name() must be implemented in the state.")
	return "no state error"
