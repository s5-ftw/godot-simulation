
## Adapter that returns no line.
## Used only for debugging or before real adapters are implemented.
class_name NoLineSensor
extends LineSensorAdapter

## Warning, always returns 0.
## @returns integer of bits.
func read() -> int:
	return 0

## Warning, populates to emptiness
func _setup_debug_ui(container: GridContainer) -> void:
	## Clear existing UI
	for child in container.get_children():
		child.queue_free()

	var text = TextMesh.new()
	text.text = "No adapter"
	text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	container.add_child(text)
	return
