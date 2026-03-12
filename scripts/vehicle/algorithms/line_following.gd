class_name LineFollowing

# Controller parameters
var Kp = 0.25
var Kd = 0.08
var max_speed = 0.65  # max forward speed
var min_speed = 0.1  # minimum speed when turning sharply

# Keep track of last error for derivative
var last_error = 0
var adapters: VehicleAdapters

var current_angle = 0
var wanted_angle = 0
var steering_speed = 0.45

func _init(
	adapters: VehicleAdapters
) -> void:
	self.adapters = adapters
	current_angle = adapters.steering.get_current()
	wanted_angle = adapters.steering.get_current()

func execute(delta):
	var sensor_value = adapters.line_sensor.read()
	
	# Calculate error based on which sensors are active
	var weights = [-4, -2, 0, 2, 4]
	var error: float = 0.0
	var active_count = 0
	
	for i in range(5):
		if sensor_value & (1 << i):
			error += weights[i]
			active_count += 1

	if active_count > 0:
		error /= active_count  # average if multiple sensors detect the line
	
	# Derivative term
	var derivative = (error - last_error) / delta
	last_error = error
	
	# Steering = proportional + derivative
	var steering = clamp(Kp * error + Kd * derivative, -1, 1)
	print(steering)
	
	## We lost the line... don't reset the steering otherwise you'll go to infinity forwards
	if sensor_value == 0:
		steering = self.adapters.steering.get_current()
		
	
	# Scale speed down for sharp turns
	var speed = max_speed * (1 - abs(steering * 0.25))
	
	# Send to motors
	adapters.driving.set_driving(speed)
	wanted_angle = steering
	adapters.steering.set_steering(smooth_steering(delta, adapters))

func lost_it() -> bool:
	return self.adapters.line_sensor.read() == 0
	
func smooth_steering(delta: float, adapters: VehicleAdapters) -> float:
	current_angle = move_toward(current_angle, wanted_angle, steering_speed * delta * (1-abs(adapters.driving.get_velocity())) )
	return current_angle
