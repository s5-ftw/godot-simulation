## Allows you to build a configuration file from yaml snippets.
## Never manually instanciate the config file.
class_name VehicleConfigBuilder
extends RefCounted

var _config: VehicleConfig
var distance_sensor_config: DistanceSensorConfig
var line_sensor_config: LineSensorConfig
var driving_config: DrivingConfig
var steering_config: SteeringConfig

static func new_builder() -> VehicleConfigBuilder:
	return VehicleConfigBuilder.new()

## Automatically builds a target object's variables with matching ones
## in a parsed YAML dictionnary.
static func populate_from_dict(target: Object, data: Dictionary) -> void:
	if target == null or data == null:
		print("No target / data given. populating not possible.")
		return
	
	# Get all editable properties on the object
	var properties := target.get_property_list()
	var valid_props := {}

	for prop in properties:
		# Only script variables (not built-in engine internals)
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			valid_props[prop.name] = true

	# Assign matching keys
	for key in data.keys():
		if valid_props.has(key):
			print("\t", key, "\t= ", data[key])
			target.set(key, data[key])

func with_config(yaml: Dictionary) -> VehicleConfigBuilder:
	if yaml.has("distance_sensor"):
		self.with_distance_sensor(yaml["distance_sensor"])
	if yaml.has("steering"):
		self.with_steering(yaml["steering"])
	if yaml.has("driving"):
		self.with_driving(yaml["driving"])
	if yaml.has("line_sensor"):
		self.with_line_sensor(yaml["line_sensor"])
	return self

func with_distance_sensor(yaml: Dictionary) -> VehicleConfigBuilder:
	print("config: adding distance sensor")
	self.distance_sensor_config = DistanceSensorConfig.new()
	self.populate_from_dict(self.distance_sensor_config, yaml)
	return self
	
func with_line_sensor(yaml: Dictionary) -> VehicleConfigBuilder:
	print("config: adding line sensor")
	self.line_sensor_config = LineSensorConfig.new()
	self.populate_from_dict(self.line_sensor_config, yaml)
	return self
	
func with_driving(yaml: Dictionary) -> VehicleConfigBuilder:
	print("config: adding driving")
	self.driving_config = DrivingConfig.new()
	self.populate_from_dict(self.driving_config, yaml)
	return self
	
func with_steering(yaml: Dictionary) -> VehicleConfigBuilder:
	print("config: adding steering")
	self.steering_config = SteeringConfig.new()
	self.populate_from_dict(self.steering_config, yaml)
	return self

func build() -> VehicleConfig:
	print("config: Building...")
	return VehicleConfig.new(
		self.distance_sensor_config,
		self.line_sensor_config,
		self.driving_config,
		self.steering_config
	)
