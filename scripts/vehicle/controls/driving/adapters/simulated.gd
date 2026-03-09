## Adapter that simulates the forward / backwards motion of the vehicle
## Connecting the program to the simulated objects rather than the actual vehicle.
class_name SimulatedDrivingAdapter
extends DrivingAdapter

var throttle: float = 0.0
var velocity: float = 0.0

var max_force: float = 0
var friction: float = 0
var max_speed: float = 0

func bind(body: Node3D) -> void:
	body.connect("_process", self._execute_driving)
	self._vehicle_node = body
	self._set_physics()

## Always returns your wanted speed.
## The real vehicle has no motor encoders.
## @returns -1: back in the future, 0:stopped, 1: need for speed.
func get_current() -> float:
	return self.throttle

## Sets the driving motors to a new value between -1 and 1.
func set_driving(new: float) -> void:
	if clamp(new,-1,1) != new:
		push_error("wanted driving value passed to set_driving out of -1 to 1 range: ", new)
		return
	self.throttle = new
	
func _execute_driving(delta: float) -> void:
	var force = self.max_force * self.throttle
	var drag = self.friction * sign(self.velocity)
	var acceleration = (force - drag) / self.config.vehicle_weight
	
	self.velocity += acceleration * delta
	self.velocity = clamp(self.velocity, -self.max_speed, max_speed)
	
	# Move in the direction the car faces
	var forward = -self._vehicle_node.transform.basis.z
	self._vehicle_node.position += forward * self.velocity * delta


## Calculates the physics of the vehicle, to approximate the acceleration and deacceleration.
func _set_physics() -> void:
	## Maximum force the car can produce.
	var usable_torque = self.config.motor_force * self.config.motor_usable_torque_ratio
	var wheel_force = usable_torque / self.config.wheel_radius
	self.max_force = wheel_force * self.config.motor_count
	
	## Friction
	self.friction = self.config.wheel_friction * 4

	var wheel_circumference = 2 * PI * (self.config.wheel_radius / 100)
	self.max_speed = (wheel_circumference * 200) / 60 # 200 RPM as maximum turns per minutes.

	print("Driving physics:")
	print("- max force: ", self.max_force)
	print("- friction:  ", self.friction)
	print("- max speed: ", self.max_speed, " m/s")
	print("\t- kmh: ", self.max_speed * 3.6)
