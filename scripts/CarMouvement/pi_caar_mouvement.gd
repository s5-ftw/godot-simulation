extends Node3D

@export var speed = 0.0
@export var max_speed = 14.0
@export var acceleration = 0.1
@export var decceleration = 0.15

func _process(delta: float) -> void:
	var direction = Vector3(0,0,1)
	
	if Input.is_key_pressed(KEY_A):
		direction.x += 1
	if Input.is_key_pressed(KEY_D):
		direction.x -= 1
		
	if Input.is_key_pressed(KEY_W):
		speed -= acceleration
	elif Input.is_key_pressed(KEY_S):
		speed += acceleration
	else:
		translate(slow_down_letting_go(delta))
		return
	
	translate(direction * speed * delta)


func slow_down_letting_go(delta: float) -> Vector3:
	var direction = Vector3(0.0,0.0,1.0)

	if speed > 0:
		if speed <= decceleration:
			speed = 0
		else:
			speed -= decceleration
	
	if speed < 0:
		if abs(speed) <= decceleration:
			speed = 0
		else:
			speed += decceleration
	
	return direction * speed * delta
