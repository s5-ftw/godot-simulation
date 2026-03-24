class_name NetworkFSMProcessState
extends StateMachineState

enum SOCKET_MESSAGE_TYPE {
	GET_DISTANCE_SENSOR = 1,
	GET_LINE_SENSOR = 2,
	SET_STEERING_OUTPUT = 3,
	SET_MOTOR_OUTPUT = 4
}

var test = 0
var adapters: VehicleAdapters

func _init(adapters: VehicleAdapters) -> void:
	adapters = adapters

func _input(event):
	pass

# Called when the state machine enters this state.
func on_enter() -> void:
	print("Network Process State entered")
	#get_parent().socket.send_text("Hello mom!")


# Called every frame when this state is active.
func on_process(delta: float) -> void:
	get_parent().socket.poll()
	var state = get_parent().socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:

		# Received packets and process them
		while get_parent().socket.get_available_packet_count():
			get_parent().data_received = JSON.parse_string(get_parent().socket.get_packet().get_string_from_utf8())
			print(get_parent().data_received)
			if get_parent().data_received == null:
				print("Error while parsing received string")

		# Send current data to send JSON packet every 50ms ish
		if test > 0.05:
			#var json_data = send_information_json(SOCKET_MESSAGE_TYPE.SET_STEERING_OUTPUT).to_utf8_buffer()
			#print(json_data)
			#get_parent().socket.send(json_data)
			#
			#json_data = send_information_json(SOCKET_MESSAGE_TYPE.SET_MOTOR_OUTPUT).to_utf8_buffer()
			#print(json_data)
			#get_parent().socket.send(json_data)
			
			test = 0
		else:
			test += delta
	elif state == WebSocketPeer.STATE_CLOSING || WebSocketPeer.STATE_CLOSING:
		get_parent().current_state = $"../NetworkDisconnectingState"

func send_information_json(info_to_send :SOCKET_MESSAGE_TYPE) -> String:
	var data_sending
	data_sending["function"] = info_to_send
	
	match info_to_send:
		SOCKET_MESSAGE_TYPE.GET_DISTANCE_SENSOR:
			print("Distance sensor")
		SOCKET_MESSAGE_TYPE.GET_LINE_SENSOR:
			print("Line sensor")
		SOCKET_MESSAGE_TYPE.SET_STEERING_OUTPUT:
			data_sending["arg"] = get_steering(adapters)
			print("Steering output")
		SOCKET_MESSAGE_TYPE.SET_MOTOR_OUTPUT:
			data_sending["arg"] = get_speed(adapters)
			print("Motor output")
		_:
			print("Unknown message")
	return JSON.stringify(data_sending)


func get_speed(adapters: VehicleAdapters) -> float:
	return adapters.driving.get_velocity() 

func get_steering(adapters: VehicleAdapters) -> float:
	return adapters.steering.get_current()

# Called every physics frame when this state is active.
func on_physics_process(delta: float) -> void:
	pass


# Called when there is an input event while this state is active.
func on_input(event: InputEvent) -> void:
	pass


# Called when the state machine exits this state.
func on_exit() -> void:
	print("Network Process State left")
