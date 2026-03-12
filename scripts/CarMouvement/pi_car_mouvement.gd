extends Node3D

@export var speed = 0.0
@export var max_speed = 10.0
@export var acceleration = 5.0
@export var decceleration = acceleration
@export var turn_speed = 0.25
@export var max_wheel_angle = 30.0

@onready var wheel_fl = $WheelFrontLeft
@onready var wheel_fr = $WheelFrontRight

# Make the wheel seem like they are turning
@export var steer_angle = 0.0

# In centimeters, whats the distance between both sets of wheels?
@export var wheel_base = 0.0

@export var max_acceleration = 0.0

func _process(delta: float) -> void:
	var distance = wheel_fl.global_position.distance_to(wheel_fr.global_position)
	wheel_base = distance
	
	speed = clamp(speed, -max_speed, max_speed)
	
	# --- Lateral acceleration limiting ---
	var limited_steer = steer_angle
	
	var v2 = speed * speed
	if v2 > 0.01:
		var max_tan = (max_acceleration * wheel_base) / v2
		var max_angle = atan(max_tan)
		limited_steer = clamp(steer_angle, -max_angle, max_angle)
	
	# Wheel mesh turning
	wheel_fl.rotation.y = limited_steer
	wheel_fr.rotation.y = limited_steer
	
	# Vehicle angular rotation
	var yaw_rate = speed * (tan(limited_steer) / wheel_base)
	rotation.y += yaw_rate * delta
		
	# Move in the direction the car faces
	var forward = -transform.basis.z
	position += forward * speed * delta
