class_name DrivingConfig
extends RefCounted

## What's the top ratio we're willing to go to?
var real_maximum: float
var real_minimum: float
## There's some advantages having the stopped speed not being 0.
var real_stopped: float
var adapter_type: String

## In meters per second, what's the top speed of the car?
var maximum_speed: float
## How strong are the motors? Dictates the acceleration.
## In newton meters
var motor_force: float
## How many motors is there on the car? Assuming the same motors for every wheel.
var motor_count: int
## How much of that torque from the motors actually gets used? 33 / 35%.
var motor_usable_torque_ratio: float
## How heavy is the vehicle? Dictates the acceleration.
## In Kilograms.
var vehicle_mass: float
## Estimated friction of the wheels. Mu.
var wheel_friction: float
## The radius, in cm, of the wheels.
var wheel_radius: float

## Wether it should be debugged in a ui
var ui_debug: bool

func _init(
	real_stopped_speed=0.0,
	real_max_speed=1.0,
	real_min_speed=-1.0,
	adapter_type="none",
	ui_debug=true,
	motor_force=0.078,
	motor_count=2,
	motor_usable_torque_ratio=0.35,
	vehicle_mass=1.3,
	wheel_friction=0.6,
	wheel_radius=3.3
):
	self.real_stopped = real_stopped_speed
	self.real_maximum = real_max_speed
	self.real_minimum = real_min_speed
	self.adapter_type = adapter_type
	self.ui_debug = ui_debug
	self.motor_force = motor_force
	self.motor_count = motor_count
	self.motor_usable_torque_ratio = motor_usable_torque_ratio
	self.vehicle_mass = vehicle_mass
	self.wheel_friction = wheel_friction
	self.wheel_radius = wheel_radius
