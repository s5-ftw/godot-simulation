extends RefCounted

## Abstract (interface) adapter for a distance sensor.
##
## All distance sensors must have an adapter between the business logic
## and the hardware logic. The goal of this one is to obtain a distance.
class_name DistanceSensorAdapter

## Abstract
##
## Obtains a distance from the distance sensor. Delays may vary.
## Distances must be in MILLIMETERS
##
## @returns millimeters
func read() -> float:
	push_error("read() must be implemented in the distance sensor adapter")
	return 0.0
