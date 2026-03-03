extends Node3D

@export var speed = 0.0
@export var max_speed = 10.0
@export var acceleration = 5.0
@export var decceleration = 4.0
@export var turn_speed = 0.25

func _process(delta: float) -> void:
	# Turning
	if Input.is_key_pressed(KEY_A):
		rotate_y(turn_speed * speed * delta)
	if Input.is_key_pressed(KEY_D):
		rotate_y(-turn_speed * speed * delta)
	
	# Acceleration
	if Input.is_key_pressed(KEY_W):
		speed += acceleration * delta
	elif Input.is_key_pressed(KEY_S):
		speed -= acceleration * delta
	else:
		slow_down_letting_go(delta)
		
	speed = clamp(speed, -max_speed, max_speed)
		
	# Move in the direction the car faces
	var forward = -transform.basis.z
	position += forward * speed * delta


func slow_down_letting_go(delta: float) -> void:
	if speed > 0:
		speed -= decceleration * delta
		if speed < 0:
			speed = 0

	elif speed < 0:
		speed += decceleration * delta
		if speed > 0:
			speed = 0
