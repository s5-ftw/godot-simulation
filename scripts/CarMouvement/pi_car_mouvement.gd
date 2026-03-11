extends Node3D

@export var speed = 0.0
@export var steer_angle = 0.0

@export var max_acceleration = 8.0

@onready var wheel_fl = $WheelFrontLeft
@onready var wheel_fr = $WheelFrontRight

@export var wheel_base = 0.0

var velocity: Vector3 = Vector3.ZERO


func _process(delta: float) -> void:

	var distance = wheel_fl.global_position.distance_to(wheel_fr.global_position)
	wheel_base = distance

	# Wheel visuals
	wheel_fl.rotation.y = steer_angle
	wheel_fr.rotation.y = steer_angle

	var forward = -transform.basis.z

	# Desired velocity from user input
	var desired_velocity = forward * speed

	# Required velocity change
	var accel = (desired_velocity - velocity) / delta

	# HARD LIMIT TOTAL ACCELERATION
	if accel.length() > max_acceleration:
		accel = accel.normalized() * max_acceleration

	# Apply
	velocity += accel * delta

	# Move
	position += velocity * delta

	# Turning based on current velocity
	var yaw_rate = (velocity.length() * (tan(steer_angle) / wheel_base))
	rotation.y += yaw_rate * delta
