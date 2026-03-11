extends Node3D

# Variables
var NetworkIPAddrRegex = RegEx.new()
var manager: VehicleManager

@onready var debug_ui_container = $DebugElementContainer
@onready var line_sensor_area = $"PiCar-col/PiCar#line_follower_sensor"
@onready var vehicle_body = $"PiCar-col"
@onready var distance_sensor_raycast = $"PiCar-col/PiCar#RayCast3D"

# Engine functions
# Called when the node enters the scene tree for the first time.
func _ready():
	NetworkIPAddrRegex.compile(r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)(\.(?!$)|$)){4}$')
	#get_node("NetworkFSM").current_state = $NetworkFSM/NetworkInitState
	
	# Vehicle creation logic and debug assignments
	manager = VehicleFactory.create("SunFounder PiCar")
	manager.bind_debug_ui(debug_ui_container)
	manager.adapters.line_sensor.bind(line_sensor_area.get_child(0))
	manager.adapters.driving.bind(vehicle_body)
	manager.adapters.steering.bind(vehicle_body)
	manager.adapters.distance_sensor._adapter.bind(distance_sensor_raycast)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var key_pressed = false
	if Input.is_key_pressed(KEY_W):
		manager.adapters.driving.set_driving(1)
		key_pressed = true
	elif Input.is_key_pressed(KEY_S):
		manager.adapters.driving.set_driving(-1)
		key_pressed = true
	else:
		manager.adapters.driving.set_driving(0)
		
	if Input.is_key_pressed(KEY_A):
		key_pressed = true
		manager.adapters.steering.set_steering(-1)
	elif Input.is_key_pressed(KEY_D):
		manager.adapters.steering.set_steering(1)
		key_pressed = true
	else:
		manager.adapters.steering.set_steering(0)
		
	if key_pressed:
		return

	manager.execute(delta)

# Signals functions
func _on_quit_pressed():
	$NetworkFSM.current_state = $NetworkFSM/NetworkClosingConnectionState
	get_tree().quit()

func _on_connect_pressed():
	# IP address REGEX before starting connection
	if get_node("GridContainer/btn_Connect").text == "Disconnect":
		$NetworkFSM.current_state = $NetworkFSM/NetworkClosingConnectionState
	else:
		var RegexResult = NetworkIPAddrRegex.search_all(get_node("GridContainer/le_IpAdress").text)
		if RegexResult.size() > 0:
			# Disable button before having a connection
			get_node("GridContainer/btn_Connect").disabled = true
			get_node("GridContainer/lb_ConnectionStatusPackets").text = "Connecting"
			get_node("NetworkFSM").current_state = $NetworkFSM/NetworkInitState
		else:
			get_node("AspectRatioContainer/GridContainer/lb_ConnectionStatusPackets").text = "Wrong IP Address!"

func _on_check_box_toggled(toggled_on):
	if toggled_on:
		$GridContainer/le_IpAdress.text = "127.0.0.1"
		get_node("NetworkFSM").current_state = $NetworkFSM/NetworkInitState

func _on_btn_test_pressed():
	print("Line sensor: ", manager.adapters.line_sensor.read())
	print("Distance: ", manager.adapters.distance_sensor.read())


func _on_btn_change_scene_pressed() -> void:
	print("scene: ", get_tree().current_scene.scene_file_path)

	if get_tree().current_scene.scene_file_path == "res://Scenes/Simulation_line_follower.tscn":
		get_tree().change_scene_to_file("res://Scenes/pi_car_mouvement.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/Simulation_line_follower.tscn")
		
