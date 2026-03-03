## Manager of state machines for the vehicle's state
## Executes the right state. Never call states individually.
class_name VehicleStateManager

var current_state: VehicleState
var adapters: VehicleAdapters

func _init(
	initial_state: GDScript,
	adapters: VehicleAdapters
) -> void:
	self.adapters = adapters
	self.current_state = initial_state.new(self)

## Executes the current state.
func execute():
	return current_state.execute()

## Tells you which state is currently stored in the state machine.
func current() -> String:
	return self.current_state.get_name()

## Sets the current state with a new state
func set_state(state: VehicleState):
	self.current_state = state.new(self)
