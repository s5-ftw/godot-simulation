## Adapter that returns the value from a simulated raycast.
class_name Simulated5LineSensor
extends LineSensorAdapter

var _real_ui_indicators: Array[ColorRect] = []
var _read_ui_indicators: Array[ColorRect] = []

var _off_real_indicator_color: Color = Color.DARK_GREEN
var _off_read_indicator_color: Color = Color.DARK_BLUE
var _on_real_indicator_color: Color = Color.GREEN
var _on_read_indicator_color: Color = Color.BLUE

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

func bind(area: Area3D) -> void:
	print("Line sensor area bound to Simulated 5 Sensor array")
	_sensor_area = area
	_sensor_area.connect("line_follower_changed", Callable(self, "real_updated"))
	_setup_raycast(
		self.config.cone_radius,
		0.05,
		self.config.distance_between_sensors,
		self.config.cone_height
	)

## Called automatically when the real detection occurs, not when the read happens
func real_updated(index: int, newArray: PackedByteArray) -> void:
	if newArray[index] == 0:
		_real_ui_indicators[index].color = self._off_real_indicator_color
	else:
		_real_ui_indicators[index].color = self._on_real_indicator_color

func _setup_raycast(width: float, height: float, spacing: float, length: float = 1.0) -> void:
	if _sensor_area == null:
		push_warning("Simulated5LineSensor: bind sensor area before setup.")
		return
	
	# Remove existing RayCast3D nodes
	for child in _sensor_area.get_children():
		if child is RayCast3D:
			child.queue_free()
	
	var count := self.config.sensor_amount
	
	# Compute centered starting position
	var total_width := (count - 1) * spacing
	var start_x := -total_width * 0.5
	
	for i in range(count):
		var ray := RayCast3D.new()
		
		# Position the ray
		ray.position = Vector3(start_x + i * spacing, height, 0)
		
		# Cast downward
		ray.target_position = Vector3(0, -length, 0)
		ray.enabled = true
		_sensor_area.add_child(ray)

## Adds debug elements to the main UI screen.
func _bind_debug_ui(container: GridContainer) -> void:
	## Clear existing UI
	for child in container.get_children():
		child.queue_free()
	
	## The drawing setup is 2 rows 2 columns.
	## One identifies what's actually read
	## The other identifies what was last read
	var layout = GridContainer.new()
	layout.columns = 2
	
	_create_debug_ui_row("read", layout, self._read_ui_indicators, self._off_read_indicator_color)
	_create_debug_ui_row("real", layout, self._real_ui_indicators, self._off_real_indicator_color)
	container.add_child(layout)
	
func _create_debug_ui_row(text: String, grid: GridContainer, indicators: Array[ColorRect], off_color: Color) -> void:
	var container = HBoxContainer.new()
	var label = Label.new()
	label.text = text
	grid.add_child(label)
	
	for i in range(self.config.sensor_amount):
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(20, 20)
		rect.color = off_color
		container.add_child(rect)
		indicators.append(rect)
	
	grid.add_child(container)
