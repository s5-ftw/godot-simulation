## Abstract (interface) adapter for steering the vehicle
##
## All vehicles must have an adapter between their steering business logic
## and the hardware logic. Steering is handled from 1 to -1
class_name SteeringAdapter
extends RefCounted

var config: DistanceSensorConfig

func _init(
	config: DistanceSensorConfig
) -> void:
	self.config = config

## Obtains a distance from the distance sensor. Delays may vary.
## Distances must be in MILLIMETERS.
##
## @returns millimeters
func read() -> float:
	push_error("read() must be implemented in the distance sensor adapter")
	return 0.0

## Distance sensors can have a minimum amount of time you need to wait before
## you can query again. This ensures that time is ready and you don't uselessly
## call the read() method.
##
## If this isn't needed and your sensor can be querried nonstop, always return
## true.
func is_ready() -> bool:
	push_error("is_ready() must be implemented in the distance sensor adapter")
	return true
