extends RefCounted
class_name DistanceFilterStrategy

## Abstract (interface) definition of a filtering strategy for the distance sensor.
##
## Your implementations should read, once implemented, like:
## "low-pass.filter(distance);"
##
## @param raw: Unfiltered distance from a simulated or real sensor.
## @return Filtered distance based on a chosen filtering strategy.
func filter(raw: float) -> float:
	push_error("filter() must be overridden! Strategy not implemented.")
	return 0.0
