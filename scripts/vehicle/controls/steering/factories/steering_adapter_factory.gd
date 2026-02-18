## Decides the steering adapter to build, from given configurations.
## This decides how the steering is done. Simulated? or real one?
class_name SteeringAdapterFactory
extends RefCounted

static func create(config: SteeringConfig) -> SteeringAdapter:
	match config.adapter_type:
		"none":
			return NoSteering.new(config)
		_:
			push_error("Unknown steering adapter")
			return null
