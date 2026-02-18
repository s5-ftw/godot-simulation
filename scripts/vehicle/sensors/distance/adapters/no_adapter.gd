extends DistanceSensorAdapter

## Adapter that returns no distance.
## Used only for debugging or before real adapters are implemented.
class_name NoDistanceSensor

## Warning, always returns 0.
## @returns millimeters
func read() -> float:
	return 0.0
