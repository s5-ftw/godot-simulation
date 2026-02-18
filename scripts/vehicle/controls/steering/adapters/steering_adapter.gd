## Abstract (interface) adapter for a distance sensor.
##
## All vehicles must have an adapter between their steering business logic
## and the hardware logic. The goal here is to translate 1,-1 ratios to
## hardware understandable values.
class_name SteeringAdapter
extends RefCounted

var config: SteeringConfig

func _init(
	from_config: SteeringConfig
) -> void:
	self.config = from_config

## Obtains the current steering value in ratio.
## This is simply because it's easier to use in maths as a ratio as convertion
## is easy to do. Only a multiplication is required. You should NEVER convert
## this to something else if you don't need to.
##
## @returns -1: left, 0:center, 1: middle.
func get_current() -> float:
	push_error("get_current() must be implemented in the steering adapter")
	return 0.0

## Sets the steering to a new value between -1 and 1.
func set_steering(new: float) -> void:
	push_error("set_steering() must be implemented in the steering adapter")
	return
