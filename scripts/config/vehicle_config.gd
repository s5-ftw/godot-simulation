## Entire configuration of the vehicle. Each components having their own config object
class_name VehicleConfig
extends RefCounted

var distance_sensor = DistanceSensorConfig
var line_sensor = LineSensorConfig
var driving = DrivingConfig
var steering = SteeringConfig

func _init(
	distance_sensor=DistanceSensorConfig.new(),
	line_sensor = LineSensorConfig.new(),
	driving = DrivingConfig.new(),
	steering = SteeringConfig.new()
):
	self.distance_sensor = distance_sensor
	self.line_sensor = line_sensor
	self.driving = driving
	self.steering = steering
