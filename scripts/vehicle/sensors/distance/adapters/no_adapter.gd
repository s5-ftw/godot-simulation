extends DistanceSensorAdapter

## Adapter that returns no distance.
## Used only for debugging or before real adapters are implemented.
class_name NoDistanceSensor

## Warning, always returns 0.
## @returns millimeters
func read() -> float:
	return self.config.min_distance

## This sensor is always ready to give you nothing
func is_ready() -> bool:
	return self.config.poll_interval == 0
