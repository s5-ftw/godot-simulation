## Abstract (interface) adapter for a line sensor.
##
## All vehicles must have an adapter between their line sensor business logic
## and the hardware logic. Ideally this would bridge the handling between
## different amount of sensors but whatever.
class_name LineSensorAdapter
extends RefCounted

var config: LineSensorConfig
var _sensor_area: Area3D

func _init(
	config: LineSensorConfig
) -> void:
	self.config = config

## Call this after instantiation to bind the adapter to the Area3D sensor node.
func bind(area: Area3D, ui_container: GridContainer = null) -> void:
	_sensor_area = area
	if ui_container:
		_setup_debug_ui(ui_container)
		
## Populates a grid container with the appropriate things
## to debug the line sensor.
func _setup_debug_ui(container: GridContainer) -> void:
	push_error("_setup_debug_ui() must be implemented in the line sensor adapter")
	return

## Obtains the current steering value in ratio.
## This is simply because it's easier to use in maths as a ratio as convertion
## is easy to do. Only a multiplication is required. You should NEVER convert
## this to something else if you don't need to.
##
## @returns -1: left, 0:center, 1: middle.
func read() -> int:
	push_error("read() must be implemented in the line sensor adapter")
	return 0
