class_name ObstacleDodge

# Dodge parameters
var dodge_speed = 0.7           # speed during dodge maneuver
var dodge_steering_right = 0.8  # steering angle to go right
var recovery_steering = -0.8    # steering to return to line
var max_dodge_time = 5000.0        # max time to spend dodging (seconds)
var forward_distance = 50.0     # extra distance to travel past obstacle

# Tracking distances & orientation
var initial_obstacle_distance = 0.0   # distance at moment dodge started
var forward_target_distance = 0.0     # same as obstacle distance
var initial_rotation_y = 0.0          # yaw when dodge begins
var return_start_rotation_y = 0.0     # yaw when return turning begins
var turn_angle = deg_to_rad(50)       # 50° angle for each turn
var returning_angle = turn_angle + (turn_angle/2)

# State tracking
var dodge_state = "idle"        # idle, turning_right, going_forward, returning
var state_timer = 0.0           # timer for state transitions
var distance_traveled = 0.0     # distance traveled since start of dodge

func _current_yaw(adapters: VehicleAdapters) -> float:
	return adapters.driving._vehicle_node.rotation.y

func execute_idle(delta, adapters: VehicleAdapters) -> bool:
	var sensor_value = adapters.distance_sensor.read()
	start_dodge(sensor_value, adapters)
	state_timer += delta
	
	return true
	
func execute_turning_right(delta, adapters: VehicleAdapters) -> bool:
	adapters.driving.set_driving(dodge_speed)
	adapters.steering.set_steering(dodge_steering_right)
	state_timer += delta
	
	# check accumulated yaw relative to start
	var yaw_diff = _current_yaw(adapters) - initial_rotation_y
	#print("[yaw_diff] ", yaw_diff)
	#print("[turn_angle] ", turn_angle)
	if abs(yaw_diff) >= abs(turn_angle):
		dodge_state = "going_forward"
		#print("[ObstacleDodge] Turned 50° right, going straight")
		return true
	return false
	
func execute_going_forward(delta, adapters: VehicleAdapters) -> bool:
	adapters.driving.set_driving(dodge_speed)
	adapters.steering.set_steering(0)
	
	distance_traveled += dodge_speed * (delta + state_timer)
	if distance_traveled >= forward_target_distance:
		dodge_state = "returning"
		return_start_rotation_y = _current_yaw(adapters)
		print("[ObstacleDodge] Forward distance reached, starting return turn")
		return true
	return false
	
func execute_returning(delta, adapters: VehicleAdapters) -> bool:
	adapters.driving.set_driving(dodge_speed * 0.8)
	adapters.steering.set_steering(recovery_steering)
	
	# stop turning after left 50° from return start
	var yaw_diff2 = return_start_rotation_y - _current_yaw(adapters)
	#print("[yaw_diff] ", yaw_diff2)
	#print("[turn_angle] ", returning_angle)
	if abs(yaw_diff2) >= abs(returning_angle):
		adapters.steering.set_steering(0)
		dodge_state = "finished"
		return true
	return false

func execute(delta, adapters: VehicleAdapters):
	return

## Call this when starting an obstacle dodge maneuver
## `obs_distance` should be the measured distance to the obstacle (cm)
func start_dodge(obs_distance: float, adapters: VehicleAdapters) -> void:
	dodge_state = "turning_right"
	state_timer = 0.0
	distance_traveled = 0.0
	initial_obstacle_distance = obs_distance
	forward_target_distance = obs_distance
	initial_rotation_y = _current_yaw(adapters)
	print("[ObstacleDodge] Starting dodge; obstacle at ", obs_distance, " cm; initial yaw=", initial_rotation_y)

## Reset to idle state and resume line following
func reset_dodge(adapters: VehicleAdapters) -> void:
	dodge_state = "idle"
	adapters.driving.set_driving(0.0)
	adapters.steering.set_steering(0.0)
	print("[ObstacleDodge] Dodge maneuver complete, resuming line following")

## Get current dodge state for debugging
func get_state() -> String:
	return dodge_state
