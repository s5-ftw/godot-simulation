extends Area3D


var line_follower_array: PackedByteArray = [0,0,0,0,0]

# Signal that observers can subscribe to
signal line_follower_changed(new_array: PackedByteArray)
func set_line_follower_at(index: int, value: int) -> void:
	if line_follower_array[index] != value:
		line_follower_array[index] = value
		emit_signal("line_follower_changed", index, line_follower_array)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for i in line_follower_array.size():
		var ray = get_child(i)
		if ray is RayCast3D:
			set_line_follower_at(i, int(ray.is_colliding()))

# Teacher's program is kept here for the eventuality that it's required.
#func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	#print("_on_body_shape_entered")
	#if body.collision_layer == 2:
		#set_line_follower_at(local_shape_index, 1)
#
#
#func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	#print("_on_body_shape_exited")
	#if body.collision_layer == 2:
		#set_line_follower_at(local_shape_index, 0)
#
#func _on_area_entered(area: Area3D) -> void:
	#print("_on_area_entered")
#
#func _on_body_exited(body: Node3D) -> void:
	#print("_on_body_exited")
#
#func _on_area_shape_exited() -> void:
	#print("_on_area_shape_exited")
#
#func _on_area_exited(area: Area3D) -> void:
	#print("_on_area_exited")
	#pass
