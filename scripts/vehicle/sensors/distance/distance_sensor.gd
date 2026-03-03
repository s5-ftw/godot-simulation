## A distance sensor object.
## Build it with a builder and use a factory to build it from a configuration.
## Never manually instanciate this object.
##
## Has built in adapter and filtering strategy
class_name DistanceSensor
extends RefCounted

var _filter
var _adapter
var _old_raw_value

# Constructor. Managed with the builder.
func _init(
	filter: DistanceFilterStrategy, 
	adapter: DistanceSensorAdapter
) -> void:
	_filter = filter
	_adapter = adapter
	_old_raw_value = 0

## Obtain the amount of milimeters the distance sensor is currently reading,
## assuming it's ready for you to read it.
## if it's not ready, the old value is simply given back to ou.
func read() -> float:
	if _adapter.is_ready():
		_old_raw_value = _adapter.read()
		_old_raw_value = _filter.filter(_old_raw_value)
	return _old_raw_value
