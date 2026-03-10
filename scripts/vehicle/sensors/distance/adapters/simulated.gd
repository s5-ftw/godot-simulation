## Basic adapter implementing noise levels from config file.
## No cone view implementations or anything
class_name SimulatedDistanceSensor
extends DistanceSensorAdapter

## Keeps track of the polling interval to avoid making you think you can poll really fast.
var next_ready_time: float = 0.0
const SOUND_SPEED_CM_PER_SEC = 34300.0 # approx 343 m/s

func bind(ray: RayCast3D) -> void:
	var direction = ray.target_position.normalized()
	ray.target_position = direction * (self.config.max_distance / 100) # cm -> meters
	self._bound_raycast = ray


## Follows precision time set in config
## @returns centimeters
func read() -> float:
	if self._bound_raycast == null:
		push_error("SimulatedDistanceSensor is not bound to a Raycast! it cannot read a distance without a raycast.")
		return 0.0

	var distance = _read_raycast_distance()
	distance = _apply_distance_boundaries(distance)
	_simulated_ideal_distance_label.text = str(distance)
	distance = _apply_precision_noise(distance)
	#var time_to_wait = _calculate_await_time(distance)
	## AWAIT LOGIC SIMULATING BEING STUCK WAITING FOR SENSOR ECHO
	##await bound_node.create_timer(time_to_wait).timeout
	
	var now = Time.get_ticks_msec()
	# You didn't wait for the poll interval to end. Your signal has higher chance to be noisy
	# because you might be detecting an old echo... Accept the limitations fam.
	if self.config.poll_interval != 0 and now < next_ready_time:
		_last_distance_reading_label.text = str(0)
		return 0.0 # TODO: FIX but not necessary

	# Next allowed read time
	next_ready_time = now + self.config.poll_interval
	_last_distance_reading_label.text = str(distance)
	return distance

func is_ready() -> bool:
	if self.config.poll_interval == 0:
		return true
	var now = Time.get_ticks_msec()
	return now >= next_ready_time
	
## If you're not threaded, everytime you TRIG, you wait x amount of ms
## for the echo to arrive. This dictate how long you'll wait based on the
## speed of sound.
func _calculate_await_time(distance_cm: float) -> float:
	# time = distance / speed * 2 (round trip)
	return (distance_cm / SOUND_SPEED_CM_PER_SEC) * 2.0

## Apply noises in a precision range to the ideal simulated distance.
func _apply_precision_noise(distance_cm: float) -> float:
	var noise = randf_range(-self.config.precision, self.config.precision)
	return distance_cm + noise

func _apply_distance_boundaries(distance_cm: float) -> float:
	if distance_cm > self.config.max_distance:
		distance_cm = self.config.max_distance
		
	if distance_cm < self.config.min_distance:
		distance_cm = self.config.min_distance
	return distance_cm

func _read_raycast_distance() -> float:
	if not self._bound_raycast.is_colliding():
		return self.config.max_distance
	
	var origin: Vector3 = self._bound_raycast.global_transform.origin
	var collision_point: Vector3 = self._bound_raycast.get_collision_point()
	var distance_to_object = origin.distance_to(collision_point) * 100 # m -> cm

	return distance_to_object











var _ui_update_timer: Timer
var _readiness_label: Label = Label.new()
var _time_to_readiness_label: Label = Label.new()
var _simulated_ideal_distance_label: Label = Label.new()
var _last_distance_reading_label: Label = Label.new()
var _collision_message_label: Label = Label.new()
var _live_ideal_distance_label: Label = Label.new()
var debug_timer: Timer

## Debug the simulated distance sensor.
func _bind_debug_ui(container: GridContainer) -> void:
	## Clear existing UI
	for child in container.get_children():
		child.queue_free()
	
	## Setup for centered text
	container.columns = 1
	
	_readiness_debug_ui_setup(container)
	_distance_debug_ui_setup(container)
	_simulation_debug_ui_setup(container)

	## UI update timer, to avoid having to deal with _process(delta)
	debug_timer = Timer.new()
	debug_timer.wait_time = 0.05 # 20 FPS UI refresh
	debug_timer.autostart = true
	debug_timer.timeout.connect(self._ui_update)
	container.add_child(debug_timer)

	#var label = Label.new()
	#label.text = "Not done yet"
	#label.add_theme_font_size_override("font_size", 12)
	#
	#label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	#
	#label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	#label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	#container.add_child(label)
	
## Debugging the readiness factor of the distance sensor.
## Is it ready to be polled? What's the poll interval? How long is left?
func _readiness_debug_ui_setup(parent_container: GridContainer) -> void:
	sub_header(parent_container, "polling")
	
	var container = GridContainer.new()
	container.columns = 3
	
	_readiness_label = Label.new()
	_readiness_label.text = "is ready"
	_readiness_label.add_theme_color_override("font_color", Color.GREEN)
	_readiness_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_readiness_label.add_theme_font_size_override("font_size", 12)
	container.add_child(_readiness_label)

	var config_polling = Label.new()
	config_polling.text = str(self.config.poll_interval) + "ms"
	config_polling.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	config_polling.add_theme_font_size_override("font_size", 12)
	container.add_child(config_polling)
	
	_time_to_readiness_label = Label.new()
	_time_to_readiness_label.text = str(self.config.poll_interval)
	_time_to_readiness_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_time_to_readiness_label.add_theme_font_size_override("font_size", 12)
	container.add_child(_time_to_readiness_label)
	
	parent_container.add_child(container)

## Debugging the read distance versus ideal simulated one.
func _distance_debug_ui_setup(parent_container: GridContainer) -> void:
	sub_header(parent_container, "last readings")
	
	var container = GridContainer.new()
	container.columns = 2
	
	var ideal = Label.new()
	ideal.text = "Ideal: "
	ideal.add_theme_font_size_override("font_size", 12)
	container.add_child(ideal)
	
	_simulated_ideal_distance_label = Label.new()
	_simulated_ideal_distance_label.text = "0"
	_simulated_ideal_distance_label.add_theme_font_size_override("font_size", 12)
	container.add_child(_simulated_ideal_distance_label)
	
	var last_read = Label.new()
	last_read.text = "Given: "
	last_read.add_theme_font_size_override("font_size", 12)
	container.add_child(last_read)
	
	_last_distance_reading_label = Label.new()
	_last_distance_reading_label.text = "0"
	_last_distance_reading_label.add_theme_font_size_override("font_size", 12)
	container.add_child(_last_distance_reading_label)
	
	parent_container.add_child(container)

func _simulation_debug_ui_setup(parent_container: GridContainer) -> void:
	sub_header(parent_container, "simulation data")
	
	var container = GridContainer.new()
	container.columns = 2
	
	var collision = Label.new()
	collision.text = "collision: "
	collision.add_theme_font_size_override("font_size", 12)
	container.add_child(collision)
	
	_collision_message_label = Label.new()
	_collision_message_label.add_theme_font_size_override("font_size", 12)
	_collision_message_label.add_theme_color_override("font_color", Color.GREEN)
	_collision_message_label.text = "none"
	container.add_child(_collision_message_label)
	
	var live_distance = Label.new()
	live_distance.add_theme_font_size_override("font_size", 12)
	live_distance.text = "Live distance"
	container.add_child(live_distance)
	
	_live_ideal_distance_label = Label.new()
	_live_ideal_distance_label.add_theme_font_size_override("font_size", 12)
	_live_ideal_distance_label.add_theme_color_override("font_color", Color.YELLOW)
	_live_ideal_distance_label.text = "none"
	container.add_child(_live_ideal_distance_label)
	
	parent_container.add_child(container)

## Avoids code duplication. Centered text indicating the debug section.
func sub_header(parent_container: GridContainer, text) -> void:
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 12)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color.DARK_GRAY)
	parent_container.add_child(label)

# Executes each x fps, to update the UI. Do not call in _process(delta)
func _ui_update() -> void:
	var now = Time.get_ticks_msec()
	var remaining = max(0, next_ready_time - now)
	self._time_to_readiness_label.text = str(remaining)

	if self.is_ready():
		_readiness_label.add_theme_color_override("font_color", Color.GREEN)
	else:
		_readiness_label.add_theme_color_override("font_color", Color.RED)
	
	var real_distance = _read_raycast_distance()
	if not self._bound_raycast.is_colliding():
		_collision_message_label.text = "none"
		_collision_message_label.add_theme_color_override("font_color", Color.YELLOW)
		_live_ideal_distance_label.text = str(self.config.max_distance)
		_live_ideal_distance_label.add_theme_color_override("font_color", Color.YELLOW)
	else:
		_live_ideal_distance_label.text = str(real_distance)
		_collision_message_label.add_theme_color_override("font_color", Color.GREEN)
		_collision_message_label.text = "in range"
		
		## Gradient colors because I can.
		var allowed_range = self.config.max_distance - self.config.min_distance
		var current_ratio = (real_distance - self.config.min_distance) / allowed_range
		current_ratio = clamp(current_ratio, 0, 1)
		
		var green = sin(current_ratio * 3.14)
		var red = 1 - green
		
		_live_ideal_distance_label.add_theme_color_override("font_color", Color.from_rgba8(int(red*255), 255, 0, 255))
		
		if real_distance > self.config.max_distance:
			_live_ideal_distance_label.add_theme_color_override("font_color", Color.ORANGE)
			_collision_message_label.add_theme_color_override("font_color", Color.RED)
			_collision_message_label.text = "above maximum"
		if real_distance < self.config.min_distance:
			_live_ideal_distance_label.add_theme_color_override("font_color", Color.ORANGE)
			_collision_message_label.add_theme_color_override("font_color", Color.RED)
			_collision_message_label.text = "below minimum"
	
