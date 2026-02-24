## Builds the proper vehicle, with its proper config, depending on the type given
class_name VehicleFactory
extends RefCounted

static func create(type: String) -> VehicleManager:
	match type:
		"SunFounder PiCar":
			var config = ConfigSingleton.get_instance().config
			var builder = PiCarBuilder.new_builder()
			
			var initial_state = DoNothingState
			
			builder.from_config(config).with_initial_state(initial_state)
			return builder.build()
		_:
			push_error("Unknown vehicle type")
			return null
