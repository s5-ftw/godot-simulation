## Decides the proper filter strategy to return based on given parameters.
class_name DistanceSensorAdapterFactory
extends RefCounted

static func create(config: DistanceSensorConfig) -> DistanceSensorAdapter:
	match config.adapter_type:
		"none":
			return NoDistanceSensor.new(config)
		_:
			push_error("Unknown distance filter type")
			return null
