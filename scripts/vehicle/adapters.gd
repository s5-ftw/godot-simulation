## Contains all the adapters of a vehicle, in one object.
class_name VehicleAdapters

var driving: DrivingAdapter
var steering: SteeringAdapter
var distance_sensor: DistanceSensorAdapter
var line_sensor: LineSensorAdapter

func _init(
	driving: DrivingAdapter,
	steering: SteeringAdapter,
	distance: DistanceSensorAdapter,
	line: LineSensorAdapter
) -> void:
	self.driving = driving
	self.steering = steering
	self.distance_sensor = distance
	self.line_sensor = line
