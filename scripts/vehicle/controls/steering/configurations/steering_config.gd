class_name SteeringConfig
extends RefCounted

## Middles can be offset from where we'd think they actually are.
var real_middle: float
## Who knows what the steering's real maximum is,,, could be in radians, degrees, bits...
var real_maximum: float
## Who knows what the steering's real minimum is.
var real_minimum: float
## Servo motors datasheet typically tells you how much angle per second they have.
## Value in degrees, not radians.
var angle_per_second: float

var adapter_type: String

## How many degrees can the wheel turn to the left? Assuming 0 degrees is straight forward.
## This is negative degrees. put the sign as -.
var left_angle_max: float

## How many degrees can the wheel turn to the right? Assuming 0 degrees is straight forward.
## This is positive degrees. put the sign as +.
var right_angle_max: float

## Distance between front wheels and back wheels.
## In centimeters. Used to simulate turning radius.
var wheel_base: float

## Distance between the steering wheels.
## In centimeters.
var track_width: float

## Wether it should be debugged in a ui
var ui_debug: bool

func _init(
	real_middle_value=0.0,
	real_maximum_value=1.0,
	real_minimum_value=-1.0,
	angle_per_second=428,
	adapter_type_value="none",
	ui_debug=true,
	left_angle_max = -45,
	right_angle_max = 45,
	wheel_base = 13,
	track_width = 9
):
	self.real_middle = real_middle_value
	self.real_maximum = real_maximum_value
	self.real_minimum = real_minimum_value
	self.angle_per_second = angle_per_second
	self.adapter_type = adapter_type_value
	self.ui_debug = ui_debug
	self.left_angle_max = left_angle_max
	self.right_angle_max = right_angle_max
	self.wheel_base = wheel_base
	self.track_width = track_width
