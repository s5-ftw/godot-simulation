class_name LineSensorConfig
extends RefCounted

## Milimeters. Useful to understand the angle of the line.
var distance_between_sensors: float
## How many sensors is there on the sensor?
var sensor_amount: int

var adapter_type: String

## Wether it should be debugged in a UI
var ui_debug: bool

var cone_radius: float
var cone_height: float

func _init(
	distance_between_sensors=180,
	sensor_amount=5,
	adapter_type="none",
	ui_debug=true,
	cone_radius=1.0,
	cone_height=1.0,
):
	self.distance_between_sensors = distance_between_sensors
	self.sensor_amount = sensor_amount
	self.adapter_type = adapter_type
	self.ui_debug
	self.cone_height=cone_height
	self.cone_radius=cone_radius
