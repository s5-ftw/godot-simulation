class_name ObstacleDodge

# Dodge parameters
var dodge_speed = 0.5           # speed during dodge maneuver
var dodge_steering_right = 0.8  # steering angle to go right
var recovery_steering = -1    # steering to return to line
var max_dodge_time = 5000.0        # max time to spend dodging (seconds)
var backup_distance = 125

# Tracking distances & orientation
var initial_obstacle_distance = 0.0   # distance at moment dodge started
var forward_target_distance = 0.0     # same as obstacle distance
var initial_rotation_y = 0.0          # yaw when dodge begins
var return_start_rotation_y = 0.0     # yaw when return turning begins
var turn_angle = deg_to_rad(40)       # 50° angle for each turn
var returning_angle = turn_angle + (turn_angle/1.3)
var current_angle = 0
var wanted_angle = 0
var steering_speed = 0.25

# State tracking
var state_timer = 0.0           # timer for state transitions
var distance_traveled = 0.0     # distance traveled since start of dodge

func _current_yaw(adapters: VehicleAdapters) -> float:
	return adapters.driving._vehicle_node.rotation.y

func execute_backup(delta, adapters: VehicleAdapters) -> bool:
	var sensor_value = adapters.distance_sensor.read()
	adapters.driving.set_driving(-dodge_speed)
	if(sensor_value >= backup_distance):
		return true
	return false

func execute_idle(delta, adapters: VehicleAdapters) -> bool:
	var sensor_value = adapters.distance_sensor.read()
	adapters.driving.set_driving(dodge_speed)
	start_dodge(sensor_value, adapters)
	print("[Velocity] ", adapters.driving.get_velocity())
	return true
	
func execute_turning_right(delta, adapters: VehicleAdapters) -> bool:
	adapters.driving.set_driving(dodge_speed)
	wanted_angle = dodge_steering_right
	adapters.steering.set_steering(smooth_steering(delta, adapters))
	state_timer += delta
	
	# check accumulated yaw relative to start
	var yaw_diff = _current_yaw(adapters) - initial_rotation_y
	#print("[yaw_diff] ", yaw_diff)
	#print("[turn_angle] ", turn_angle)
	if abs(yaw_diff) >= abs(turn_angle):
		print("[ObstacleDodge] Turned 50° right, going straight")
		return true
	return false
	
func execute_going_forward(delta, adapters: VehicleAdapters) -> bool:
	adapters.driving.set_driving(dodge_speed)
	wanted_angle = 0
	adapters.steering.set_steering(smooth_steering(delta, adapters))
	
	distance_traveled += adapters.driving.get_velocity() * (delta + state_timer)
	if distance_traveled >= forward_target_distance:
		return_start_rotation_y = _current_yaw(adapters)
		print("[ObstacleDodge] Forward distance reached, starting return turn")
		return true
	return false
	
func execute_returning(delta, adapters: VehicleAdapters) -> bool:
	adapters.driving.set_driving(dodge_speed)
	wanted_angle = recovery_steering
	adapters.steering.set_steering(smooth_steering(delta, adapters))
	
	# stop turning after left 50° from return start
	var yaw_diff2 = return_start_rotation_y - _current_yaw(adapters)
	#print("[yaw_diff] ", yaw_diff2)
	#print("[turn_angle] ", returning_angle)
	if abs(yaw_diff2) >= abs(returning_angle):
		adapters.steering.set_steering(0)
		return true
	return false
	
func execute_find_center_line(delta, adapters: VehicleAdapters) -> bool:
	adapters.driving.set_driving(dodge_speed)
	wanted_angle = 0
	adapters.steering.set_steering(smooth_steering(delta, adapters))
	var sensor_value = adapters.line_sensor.read()
	if(sensor_value & 0x04 == 0x04):
		return true
	return false

func execute(delta, adapters: VehicleAdapters):
	return

## Call this when starting an obstacle dodge maneuver
## `obs_distance` should be the measured distance to the obstacle (cm)
func start_dodge(obs_distance: float, adapters: VehicleAdapters) -> void:
	state_timer = 0.0
	distance_traveled = 0.0
	initial_obstacle_distance = obs_distance
	forward_target_distance = obs_distance
	initial_rotation_y = _current_yaw(adapters)
	print("[ObstacleDodge] Starting dodge; obstacle at ", obs_distance, " cm; initial yaw=", initial_rotation_y)

## Reset to idle state and resume line following
func reset_dodge(adapters: VehicleAdapters) -> void:
	adapters.driving.set_driving(0.0)
	adapters.steering.set_steering(0.0)
	print("[ObstacleDodge] Dodge maneuver complete, resuming line following")
	
func smooth_steering(delta: float, adapters: VehicleAdapters) -> float:
	current_angle = move_toward(current_angle, wanted_angle, steering_speed * delta * (1-abs(adapters.driving.get_velocity())) )
	return current_angle
	
	
