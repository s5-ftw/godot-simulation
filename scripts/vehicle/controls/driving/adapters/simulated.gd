## Adapter that simulates the forward / backwards motion of the vehicle
## Connecting the program to the simulated objects rather than the actual vehicle.
class_name SimulatedDriving
extends DrivingAdapter

var throttle: float = 0.0
var velocity: float = 0.0
var old_velocity: float = 0.0

# expose velocity through the base-class interface
func get_velocity() -> float:
	return velocity

var max_force: float = 0
var friction: float = 0
var max_speed: float = 0

func bind(body: Node3D) -> void:
	self._vehicle_node = body
	self._set_physics()
	
	# Can't use _process(data). Because first time doing GoDot = not knowing proper developpement technique for it.
	# and proper dev techniques = redoing everything.
	var drive_timer = Timer.new()
	drive_timer.wait_time = 0.0167 # ~60Hz
	drive_timer.autostart = true
	drive_timer.timeout.connect(func(): _execute_driving(drive_timer.wait_time))
	body.add_child(drive_timer)

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
	_wanted_throttle.text = str(new)
	self.throttle = new
	
func _execute_driving(delta: float) -> void:
	# Motor force scaled by speed (simple back-EMF effect)
	var effective_force = self.max_force * self.throttle * (1 - abs(self.velocity) / self.max_speed)

	# Friction / drag
	var drag = self.friction * sign(self.velocity)

	# Acceleration
	var acceleration = (effective_force - drag) / self.config.vehicle_weight
	acceleration = clamp(acceleration, -self.config.maximum_acceleration, self.config.maximum_acceleration)
	self.velocity += acceleration * delta

	# Prevent velocity sign flip due to drag
	if sign(self.velocity) != sign(self.old_velocity) and effective_force == 0:
		self.velocity = 0
	self.old_velocity = self.velocity

	# Apply to node
	self._vehicle_node.speed = self.velocity
	
	_force_label.text = str(snapped(effective_force, 0.0001))
	_acceleration_label.text = str(snapped(acceleration, 0.0001))
	_velocity_ratio_label.text = str(snapped(self.velocity / self.max_speed, 0.0001))
	_speed_label.text = str(snapped(self.velocity, 0.0001))

## Calculates the physics of the vehicle, to approximate the acceleration and deacceleration.
func _set_physics() -> void:
	## Maximum force the car can produce.
	var usable_torque = self.config.motor_force * self.config.motor_usable_torque_ratio
	var wheel_force = usable_torque / (self.config.wheel_radius / 100)
	self.max_force = wheel_force * self.config.motor_count
	
	## Friction
	self.friction = self.config.wheel_friction

	var wheel_circumference = 2 * PI * (self.config.wheel_radius / 100)
	self.max_speed = (wheel_circumference * 500) / 60 # 200 RPM as maximum turns per minutes.

	print("Driving physics:")
	print("- max force: ", self.max_force)
	print("- friction:  ", self.friction)
	print("- max speed: ", self.max_speed, " m/s")
	print("\t- kmh: ", self.max_speed * 3.6)








var _wanted_throttle: Label = Label.new()
var _velocity_ratio_label: Label = Label.new()
var _speed_label: Label = Label.new()
var _force_label: Label = Label.new()
var _acceleration_label: Label = Label.new()

## Adds debug elements to the main UI screen.
func _bind_debug_ui(container: GridContainer) -> void:
	## Clear existing UI
	for child in container.get_children():
		child.queue_free()
	
	_throttle_debug_ui(container)
	_physics_debug_ui(container)
	
func _throttle_debug_ui(parent_container: GridContainer) -> void:
	sub_header(parent_container, "throttle")
	var container = GridContainer.new()
	container.columns = 2
	
	var wanted_label = Label.new()
	wanted_label.add_theme_font_size_override("font_size", 12)
	wanted_label.text = "wanted:"
	container.add_child(wanted_label)
	
	_wanted_throttle = Label.new()
	_wanted_throttle.add_theme_font_size_override("font_size", 12)
	_wanted_throttle.text = "0"
	container.add_child(_wanted_throttle)
	
	var current_label = Label.new()
	current_label.add_theme_font_size_override("font_size", 12)
	current_label.text = "current:"
	container.add_child(current_label)
	
	_velocity_ratio_label = Label.new()
	_velocity_ratio_label.add_theme_font_size_override("font_size", 12)
	_velocity_ratio_label.text = "0"
	container.add_child(_velocity_ratio_label)
	parent_container.add_child(container)
	
func _physics_debug_ui(parent_container: GridContainer) -> void:
	sub_header(parent_container, "simulated physics")
	var container = GridContainer.new()
	container.columns = 2
	
	var speed_title = Label.new()
	speed_title.add_theme_font_size_override("font_size", 12)
	speed_title.text = "speed: "
	container.add_child(speed_title)
	
	_speed_label = Label.new()
	_speed_label.add_theme_font_size_override("font_size", 12)
	_speed_label.text = "0"
	container.add_child(_speed_label)
	
	var acceleration_title = Label.new()
	acceleration_title.add_theme_font_size_override("font_size", 12)
	acceleration_title.text = "accel: "
	container.add_child(acceleration_title)
	
	_acceleration_label = Label.new()
	_acceleration_label.add_theme_font_size_override("font_size", 12)
	_acceleration_label.text = "0"
	container.add_child(_acceleration_label)
	parent_container.add_child(container)
	
	var force_title = Label.new()
	force_title.add_theme_font_size_override("font_size", 12)
	force_title.text = "force: "
	container.add_child(force_title)
	
	_force_label = Label.new()
	_force_label.add_theme_font_size_override("font_size", 12)
	_force_label.text = "0"
	container.add_child(_force_label)
	
func sub_header(parent_container: GridContainer, text: String) -> void:
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 12)
	
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	parent_container.add_child(label)
