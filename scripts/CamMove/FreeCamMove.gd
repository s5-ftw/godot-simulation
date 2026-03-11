extends Node3D

var move_speed = 10.0
var mouse_sensitivity = 0.003
var rotating = false

var pitch = 0.0  # vertical rotation

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # optional, you can hide later

func _process(delta: float) -> void:
	free_cam_move(delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			rotating = event.pressed

	if event is InputEventMouseMotion and rotating:
		# Horizontal rotation (yaw)
		rotate_y(-event.relative.x * mouse_sensitivity)

		# Vertical rotation (pitch)
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -1.5, 1.5)  # prevent flipping
		var r = rotation
		r.x = pitch
		rotation = r

func free_cam_move(delta):
	var direction = Vector3.ZERO

	if Input.is_key_pressed(KEY_W):
		direction -= transform.basis.z
	if Input.is_key_pressed(KEY_S):
		direction += transform.basis.z
	if Input.is_key_pressed(KEY_A):
		direction -= transform.basis.x
	if Input.is_key_pressed(KEY_D):
		direction += transform.basis.x

	if direction != Vector3.ZERO:
		direction = direction.normalized()

	global_position += direction * move_speed * delta
