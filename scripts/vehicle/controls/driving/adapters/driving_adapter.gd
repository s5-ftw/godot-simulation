## Abstract (interface) adapter for the driving motors.
##
## All vehicles must have an adapter between their driving business logic
## and the hardware logic. The goal here is to translate 1,-1 ratios to
## hardware understandable values.
class_name DrivingAdapter
extends RefCounted

var config: DrivingConfig
var _vehicle_node: Node3D

func _init(
	config: DrivingConfig
) -> void:
	self.config = config

## Call this after instantiation to bind the adapter to the vehicle's body.
func bind(body: Node3D) -> void:
	_vehicle_node = body

## Obtains the current driving motor value in ratio.
## This is simply because it's easier to use in maths as a ratio as convertion
## is easy to do. Only a multiplication is required. You should NEVER convert
## this to something else if you don't need to.
##
## @returns -1: back in the future, 0:stopped, 1: need for speed.
func get_current() -> float:
	push_error("get_current() must be implemented in the driving adapter")
	return 0.0

## Sets the driving motors to a new value between -1 and 1.
func set_driving(new: float) -> void:
	push_error("set_driving() must be implemented in the driving adapter")
	return
