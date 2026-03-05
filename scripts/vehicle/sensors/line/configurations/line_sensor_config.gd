class_name LineSensorConfig
extends RefCounted

## Milimeters. Useful to understand the angle of the line.
var distance_between_sensors: float
## How many sensors is there on the sensor?
var sensor_amount: int

var adapter_type: String

## Wether it should be debugged in a UI
var ui_debug: bool

func _init(
	distance_between_sensors=180,
	sensor_amount=5,
	adapter_type="none",
	ui_debug=true
):
	self.distance_between_sensors = distance_between_sensors
	self.sensor_amount = sensor_amount
	self.adapter_type = adapter_type
	self.ui_debug
