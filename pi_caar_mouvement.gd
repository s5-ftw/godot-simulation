extends RigidBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector3.ZERO
	if Input.is_key_pressed(KEY_W):
		direction.x += 1
	if Input.is_key_pressed(KEY_S):
		direction.x -= 1
	if Input.is_key_pressed(KEY_A):
		direction.z += 1
	if Input.is_key_pressed(KEY_D):
		direction.z -= 1
		
	apply_force(direction*5)
