## Decides the line sensor adapter to build, from given configurations.
## This project only has the one SunFounder line sensor, but must decide
## if its being simulated or not.
class_name LineSensorAdapterFactory
extends RefCounted

static func create(config: LineSensorConfig) -> LineSensorAdapter:
	match config.adapter_type:
		"none":
			return NoLineSensor.new(config)
		"simulated":
			var adapter = Simulated5LineSensor.new(config)
			return
		_:
			push_error("Unknown line sensor adapter")
			return null
