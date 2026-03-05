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

## Assign a debug grid to each adapters that contains a "_bind_debug_ui" method.
func bind_debug_ui(container: GridContainer)-> void:
	var properties = adapters.get_property_list()
	for property in properties:
		var property_name = property["name"]
		var member = adapters.get(property_name)

		if typeof(member) == TYPE_OBJECT and member != null:
			if member.has_method("_bind_debug_ui"):
				var grid_container = GridContainer.new()
				container.add_child(grid_container)
				member._bind_debug_ui(grid_container)
				print("Debug UI created for: ", property_name)
	return

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
