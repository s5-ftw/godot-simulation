class_name LineFollowing

# Controller parameters
var Kp = 0.25
var Kd = 0.08
var max_speed = 0.6  # max forward speed
var min_speed = 0.1  # minimum speed when turning sharply

# Keep track of last error for derivative
var last_error = 0
var adapters: VehicleAdapters

func _init(
	adapters: VehicleAdapters
) -> void:
	self.adapters = adapters

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
	var speed = max_speed * (1 - abs(steering * 0.2))
	
	# Send to motors
	adapters.driving.set_driving(speed)
	adapters.steering.set_steering(steering)

func lost_it() -> bool:
	return self.adapters.line_sensor.read() == 0
