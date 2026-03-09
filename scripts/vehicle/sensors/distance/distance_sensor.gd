## A distance sensor object.
## Build it with a builder and use a factory to build it from a configuration.
## Never manually instanciate this object.
##
## Has built in adapter and filtering strategy
class_name DistanceSensor
extends RefCounted

var _filter: DistanceFilterStrategy
var _adapter: DistanceSensorAdapter
var _old_raw_value: float

# Constructor. Managed with the builder.
func _init(
	filter: DistanceFilterStrategy, 
	adapter: DistanceSensorAdapter
) -> void:
	self._filter = filter
	self._adapter = adapter
	self._old_raw_value = 0

## Obtain the amount of centimeters the distance sensor is currently reading,
## assuming it's ready for you to read it.
## if it's not ready, the old value is simply given back to you.
func read() -> float:
	if self._adapter.is_ready():
		self._old_raw_value = self._adapter.read()
		self._old_raw_value = self._filter.apply(_old_raw_value)
	return self._old_raw_value
