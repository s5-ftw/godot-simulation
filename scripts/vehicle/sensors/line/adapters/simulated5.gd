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
	
## Adds debug elements to the main UI screen.
func _bind_debug_ui(container: GridContainer) -> void:
	## Clear existing UI
	for child in container.get_children():
		child.queue_free()
	
	## Setup for centered text
	container.columns = 1

	var label = Label.new()
	label.text = "This works"
	label.add_theme_font_size_override("font_size", 12)
	
	# 4. SET EXPANSION FLAGS
	# This tells the GridContainer: "Give this child as much room as possible"
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	container.add_child(label)
