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

var adapter_type: String

func _init(
	real_middle_value=0.0,
	real_maximum_value=1.0,
	real_minimum_value=-1.0,
	step_size_value=0.0,
	adapter_type_value="none"
):
	self.real_middle = real_middle_value
	self.real_maximum = real_maximum_value
	self.real_minimum = real_minimum_value
	self.step_size = step_size_value
	self.adapter_type = adapter_type_value
