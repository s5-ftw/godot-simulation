
## Adapter that simulates the steering based off characteristics.
class_name SimulatedSteering
extends SteeringAdapter

var steering: float = 0.0
var current_angle: float = 0.0
var old_angle: float = 0.0

func bind(body: Node3D) -> void:
	self._vehicle_node = body
	self._vehicle_node.wheel_base = self.config.wheel_base / 100
	
	# Can't use _process(data). Because first time doing GoDot = not knowing proper developpement technique for it.
	# and proper dev techniques = redoing everything.
	var steer_timer = Timer.new()
	steer_timer.wait_time = 0.0167 # ~60Hz
	steer_timer.autostart = true
	steer_timer.timeout.connect(func(): _execute_steering(steer_timer.wait_time))
	body.add_child(steer_timer)

## Returns the actual steering.
## The real vehicle has stepper motors which I hope can return where they are.
## @returns -1: complete left, 0:middle, 1: complete right
func get_current() -> float:
	return self.steering

## Sets the steering to a new value between -1 and 1.
func set_steering(new: float) -> void:
	if clamp(new,-1,1) != new:
		push_error("wanted steering value passed to set_steering out of -1 to 1 range: ", new)
		return
	self.steering = new
	
func _execute_steering(delta: float) -> void:
	var angle_range = -self.config.left_angle_max + self.config.right_angle_max
	var wanted_angle = ((self.steering + 1)/2) * angle_range
	wanted_angle = wanted_angle + self.config.left_angle_max
	self.current_angle = move_toward(
			self.current_angle,
			wanted_angle,
			self.config.angle_per_second * delta
		)
	## Making the wheels visually rotate.
	var radians = deg_to_rad(-self.current_angle)
	self._vehicle_node.steer_angle = radians
