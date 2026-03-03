class_name DrivingConfig
extends RefCounted

## What's the top ratio we're willing to go to?
var real_maximum: float
var real_minimum: float
## There's some advantages having the stopped speed not being 0.
var real_stopped: float

var adapter_type: String

func _init(
	real_stopped_speed=0.0,
	real_max_speed=1.0,
	real_min_speed=-1.0,
	adapter_type="none"
):
	self.real_stopped = real_stopped_speed
	self.real_maximum = real_max_speed
	self.real_minimum = real_min_speed
	self.adapter_type = adapter_type
