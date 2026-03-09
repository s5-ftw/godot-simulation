extends Node3D

# Variables
var NetworkIPAddrRegex = RegEx.new()
var manager: VehicleManager

@onready var debug_ui_container = $DebugElementContainer
@onready var line_sensor_area = $"PiCar-col/PiCar#line_follower_sensor"
@onready var vehicle_body = $"PiCar-col"

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
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_W):
		manager.adapters.driving.set_driving(1)
	elif Input.is_key_pressed(KEY_S):
		manager.adapters.driving.set_driving(-1)
	else:
		manager.adapters.driving.set_driving(0)

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
	print(manager.adapters.line_sensor.read())
