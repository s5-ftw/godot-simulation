extends Area3D


var line_follower_array: PackedByteArray = [0,0,0,0,0]

# Signal that observers can subscribe to
signal line_follower_changed(new_array: PackedByteArray)
func set_line_follower_at(index: int, value: int) -> void:
	if line_follower_array[index] != value:
		line_follower_array[index] = value
		emit_signal("line_follower_changed", index, line_follower_array)
		

var _initial_y: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self._initial_y = global_position.y
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta): # Use physics_process instead
	var time = Time.get_ticks_msec() / 1000.0
	var offset = sin(time * 2.0) * 0.5
	global_position.y = _initial_y + offset
	
	for i in line_follower_array.size():
		var ray = get_child(i)
		if ray is RayCast3D:
			set_line_follower_at(i, int(ray.is_colliding()))

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("_on_body_shape_entered")
	if body.collision_layer == 2:
		set_line_follower_at(local_shape_index, 1)
	print(line_follower_array)


func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	print("_on_body_shape_exited")
	if body.collision_layer == 2:
		set_line_follower_at(local_shape_index, 0)

func _on_area_entered(area: Area3D) -> void:
	print("_on_area_entered")

func _on_body_exited(body: Node3D) -> void:
	print("_on_body_exited")

func _on_area_shape_exited() -> void:
	print("_on_area_shape_exited")

func _on_area_exited(area: Area3D) -> void:
	print("_on_area_exited")
	pass # Replace with function body.
