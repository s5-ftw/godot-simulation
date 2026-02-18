## Decides the proper filter strategy to return based on given parameters.
class_name DistanceFilterStrategyFactory
extends RefCounted

static func create(config: DistanceSensorConfig) -> DistanceFilterStrategy:
	match config.filter_type:
		"none":
			return NoFilter.new()
		_:
			push_error("Unknown distance filter type")
			return null
