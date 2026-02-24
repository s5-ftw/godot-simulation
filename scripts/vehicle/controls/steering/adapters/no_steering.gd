
## Adapter that doesn't do shit with the steering.
## Used only for debugging or before real adapters are implemented.
class_name NoSteering
extends SteeringAdapter

## Will always return the center value.
func get_current() -> float:
	return 0

## Doesn't do shit dawg
func set_steering(new: float) -> void:
	return
