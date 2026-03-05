## Adapter that returns the value from a simulated raycast.
class_name Simulated5LineSensor
extends LineSensorAdapter

## Reads the 5-sensor array from the Area3D and packs it into an integer.
## Bit layout (LSB first): bit 0 = sensor 0, bit 4 = sensor 4.
## Example: sensors [0,1,0,1,0] → 0b01010 → 10
## @returns integer of bits representing sensor state. Returns 0 if not bound.
func read() -> int:
	if _sensor_area == null:
		push_warning("Simulated5LineSensor: not bound to an Area3D. Call bind() first.")
		return 0

	var result := 0
	var arr: PackedByteArray = _sensor_area.line_follower_array

	for i in arr.size():
		if arr[i]:
			result |= (1 << i)

	return result
