
## Adapter that returns no line.
## Used only for debugging or before real adapters are implemented.
class_name NoLineSensor
extends LineSensorAdapter

## Warning, always returns 0.
## @returns integer of bits.
func read() -> int:
	return 0

## Warning, populates to emptiness
func _bind_debug_ui(container: GridContainer) -> void:
	## Clear existing UI
	for child in container.get_children():
		child.queue_free()
	
	## Setup for centered text
	container.columns = 1

	var label = Label.new()
	label.text = "No Line sensor adapter"
	label.add_theme_font_size_override("font_size", 12)
	
	# 4. SET EXPANSION FLAGS
	# This tells the GridContainer: "Give this child as much room as possible"
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	container.add_child(label)
