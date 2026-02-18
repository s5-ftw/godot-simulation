## Adapter that doesn't do shit with the driving.
## Used only for debugging or before real adapters are implemented.
class_name NoDriving
extends DrivingAdapter

## Will always return the stopped value.
func get_current() -> float:
	return 0

## Doesn't do shit dawg
func set_driving(new: float) -> void:
	return
