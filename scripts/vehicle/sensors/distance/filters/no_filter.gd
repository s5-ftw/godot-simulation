extends DistanceFilterStrategy
class_name NoFilter

## Returns the raw value as is, not filtered or altered at all.
##
## @param raw: Unfiltered distance from a simulated or real sensor.
## @return raw directly returned.
func filter(raw: float) -> float:
	return raw
