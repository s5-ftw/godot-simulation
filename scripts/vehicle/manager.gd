## Manages the vehicle autonomously, by executing states
## That changes with each others, which calls the proper
## adapters
class_name VehicleManager

var state_manager: VehicleStateManager
var adapters: VehicleAdapters

func _init(
	manager: VehicleStateManager,
	adapters: VehicleAdapters
) -> void:
	self.state_manager = manager
	self.adapters = adapters

## Executes the current state.
func execute():
	return self.state_manager.execute()

## Tells the vehicle to stop.
func stop():
	# NOT DONE
	return

## Tells the vehicle to start
func start():
	## Not done
	return
