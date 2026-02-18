## Decides the proper distance sensor to build, from given configurations.
## This project only has the SRF05
class_name SteeringAdapterFactory
extends RefCounted

static func create(config: SteeringConfig) -> SteeringAdapter:
	match config.adapter_type:
		"none":
			return NoSteering.new(config)
		_:
			push_error("Unknown steering adapter")
			return null
