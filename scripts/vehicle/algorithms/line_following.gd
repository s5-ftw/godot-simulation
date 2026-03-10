class_name LineFollowing

# Controller parameters
var Kp = 0.05         # proportional gain
var Kd = 0.0001         # derivative gain
var max_speed = 0.9  # max forward speed
var min_speed = 0.1  # minimum speed when turning sharply

# Keep track of last error for derivative
var last_error = 0

func execute(delta, manager: VehicleManager):
	var sensor_value = manager.adapters.line_sensor.read()
	
	if sensor_value == 0:
		# Line lost: stop or try to turn in last known direction
		manager.adapters.driving.set_driving(0)
		manager.adapters.steering.set_steering(0)
		return
	
	# Calculate error based on which sensors are active
	var weights = [-2, -1, 0, 1, 2]
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
	
	# Scale speed down for sharp turns
	var speed = max_speed * (1 - abs(steering))
	
	# Send to motors
	manager.adapters.driving.set_driving(speed)
	manager.adapters.steering.set_steering(steering)
