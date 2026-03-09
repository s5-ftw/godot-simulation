class_name DistanceSensorConfig
extends RefCounted

var min_distance: float
var max_distance: float
var poll_interval: float
var adapter_type: String
var filter_type: String
var sensor_type: String
var precision: float
## Wether it should be debugged in a UI
var ui_debug: bool

func _init(
	sensor_type="SRF05",
	adapter_type="none",
	filter_type="none",
	min_distance=0.0,
	max_distance=6942069.0,
	poll_interval=0,
	precision=0.3
	ui_debug=true
):
	self.min_distance = min_distance
	self.max_distance = max_distance
	self.poll_interval = poll_interval
	self.adapter_type = adapter_type
	self.filter_type = filter_type
	self.sensor_type = sensor_type
	self.precision = precision
	self.ui_debug = ui_debug
