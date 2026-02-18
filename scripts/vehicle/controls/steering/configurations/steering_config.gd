class_name SteeringConfig
extends RefCounted

## Middles can be offset from where we'd think they actually are.
var real_middle: float
## Who knows what the steering's real maximum is,,, could be in radians, degrees, bits...
var real_maximum: float
## Who knows what the steering's real minimum is.
var real_minimum: float
## Stepper motors take steps to increase. How much are these?
var step_size: float

func _init(
	real_middle=0.0,
	real_maximum=1.0,
	real_minimum=-1.0,
	step_size=0.0
):
	self.real_middle = real_middle
	self.real_maximum = real_maximum
	self.real_minimum = real_minimum
	self.step_size = step_size
