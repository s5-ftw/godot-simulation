
## Adapter that returns no line.
## Used only for debugging or before real adapters are implemented.
class_name NoLineSensor
extends LineSensorAdapter

## Warning, always returns 0.
## @returns integer of bits.
func read() -> int:
	return 0
