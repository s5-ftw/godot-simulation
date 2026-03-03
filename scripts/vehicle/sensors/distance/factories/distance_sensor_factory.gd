## Decides the proper distance sensor to build, from given configurations.
## This project only has the SRF05
class_name DistanceSensorFactory
extends RefCounted

static func create(config: DistanceSensorConfig) -> DistanceSensor:
	var builder = DistanceSensorBuilder.new_builder()
	match config.sensor_type:
		"SRF05":
			builder.from_config(config)
			return builder.build()
		_:
			push_error("Unknown distance sensor type type")
			return null
