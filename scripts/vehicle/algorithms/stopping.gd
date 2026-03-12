## Calculates stopping distances, and stuff like that.
## Calls sensors constantly, it's thus impossible for you to do your own delta
## or management if you call this. Instanciate only ONCE per state.
class_name Stopping

## You need 2 distance sensor readings to make this work.
var is_ready: bool = false
var _adapters: VehicleAdapters
var current_distance: float = 0
var previous_distance: float = 0
var previous_speed: float = 0
var speed: float = 0
var acceleration: float = 0
var time_of_last_reading: float = 0
var poll_interval: float = 0

var distance_safety_margin: float = 0.5

func _init(
	adapters: VehicleAdapters,
	poll_interval: int = 0
) -> void:
	self._adapters = adapters
	if poll_interval == 0:
		self.poll_interval = self._adapters.distance_sensor.config.poll_interval
	else:
		self.poll_interval = poll_interval

func update(delta):
	if (Time.get_ticks_msec() - self.time_of_last_reading) > self.poll_interval:
		self._gather_data()
		if speed != 0 and previous_speed != 0:
			self.is_ready = true

## True if stopping the vehicle is required to avoid an obstacle
func required() -> bool:
	if self._adapters.distance_sensor.above_range():
		return false
	return self.required_distance_to_stop() + distance_safety_margin > self.current_distance - distance_safety_margin * 2

## Obtaining distance with speed and acceleration.
## Formula is v^2 / 2*a
## returns meters.
func required_distance_to_stop() -> float:
	var max_acceleration = self._adapters.driving.config.maximum_acceleration
	return (abs(self.speed) * abs(self.speed)) / (2 * max_acceleration)

## How much distance until you're completely stopped at your current acceleration?
func current_distance_to_stop() -> float:
	return (abs(self.speed) * abs(self.speed)) / (2 * abs(self.acceleration))

## If the distance you need to stop is greated than the required distance to stop... you're lowkey fucked.
func will_collide() -> bool:
	#if current_distance_to_stop() > (self.current_distance + distance_safety_margin):
		#print("will collide: ", current_distance_to_stop() > (self.current_distance + distance_safety_margin))
	#print("- current_distance_to_stop:  ", current_distance_to_stop())
	#print("- required_distance_to_stop: ", (required_distance_to_stop() - distance_safety_margin))
	#print("		- speed: ", self.speed)
	#print("		- accel: ", self.acceleration)
	#print("		- dist: ", self.current_distance)
	if self._adapters.distance_sensor.above_range():
		return false
	return required_distance_to_stop() > self.current_distance - distance_safety_margin

## Nothing to worry about, you don't need to stop.
func no_worries() -> bool:
	#if self.current_distance > current_distance_to_stop() + distance_safety_margin:
		#print("no_worries: ", self.current_distance > current_distance_to_stop() + distance_safety_margin)
		#print("- self.current_distance:  ", self.current_distance)
		#print("- required_distance_to_stop: ", required_distance_to_stop() + distance_safety_margin)
		#print("		- speed: ", self.speed)
		#print("		- accel: ", self.acceleration)
	if self._adapters.distance_sensor.above_range():
		return true
	return required_distance_to_stop() < self.current_distance - distance_safety_margin

## You won't collide but there's also worries that you will.
## Essentially, the distance sensor is within safety margins.
func impossible_to_move() -> bool:
	return self.current_distance < self.distance_safety_margin + self._adapters.distance_sensor.config.precision

## We dont know when we stopped moving. This tells you.
func distance_stabelized() -> bool:
	return abs(self.current_distance - self.previous_distance) < self._adapters.distance_sensor.config.precision * 1.5

## Updates all the sensors and data fetched from them.
func _gather_data() -> void:
	self._update_speed()
	self._update_acceleration()

func _update_speed() -> void:
	if !self._adapters.distance_sensor.is_ready():
		return
	
	self.previous_distance = self.current_distance
	self.current_distance = self._adapters.distance_sensor.read() / 100
	var current_time = Time.get_ticks_msec()
	
	var delta_time = current_time - self.time_of_last_reading
	var delta_distance = self.previous_distance - self.current_distance
	
	var in_seconds = delta_time / 1000
	var new_speed = delta_distance / in_seconds
	
	self.time_of_last_reading = current_time
	self.previous_speed = self.speed
	self.speed = new_speed
	
func _update_acceleration() -> void:
	self.acceleration = self.speed - self.previous_speed
