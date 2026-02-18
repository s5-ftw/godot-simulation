## Decides the driving adapter to build, from given configurations.
## This decides how the motors are driven. Simulated? or real ones?
class_name DrivingAdapterFactory
extends RefCounted

static func create(config: DrivingConfig) -> DrivingAdapter:
	match config.adapter_type:
		"none":
			return NoDriving.new(config)
		_:
			push_error("Unknown driving adapter")
			return null
