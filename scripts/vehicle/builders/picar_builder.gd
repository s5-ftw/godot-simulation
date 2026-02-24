## Allows you to build a distance sensor in various ways for real implementations or debug scripts.
## Real implementations should only build from a config.
## Debug and tests implementations are free to build it any ways they want.
## Default config is used if none is provided.
class_name PiCarBuilder
extends VehicleBuilder

var driving: DrivingAdapter
var steering: SteeringAdapter
var distance: DistanceSensorAdapter
var line: LineSensorAdapter
var initial_state: GDScript

static func new_builder() -> PiCarBuilder:
	print("New PiCar vehicle builder")
	return PiCarBuilder.new()

## Build everything from a config object.
func from_config(config: VehicleConfig) -> PiCarBuilder:
	print("PiCar From config")
	print(config)
	print(config.driving)
	return self.with_driving_config(config.driving).with_steering_config(config.steering).with_steering_config(config.steering).with_distance_config(config.distance_sensor).with_line_config(config.line_sensor)
	
func with_driving_config(config: DrivingConfig) -> PiCarBuilder:
	self.driving = DrivingAdapterFactory.create(config)
	return self
	
func with_steering_config(config: SteeringConfig) -> PiCarBuilder:
	self.steering = SteeringAdapterFactory.create(config)
	return self
	
func with_distance_config(config: DistanceSensorConfig) -> PiCarBuilder:
	self.distance = DistanceSensorAdapterFactory.create(config)
	return self
	
func with_line_config(config: LineSensorConfig) -> PiCarBuilder:
	self.line = LineSensorAdapterFactory.create(config)
	return self
	
func with_initial_state(state: GDScript) -> PiCarBuilder:
	print("with initial state")
	self.initial_state = state
	return self

func build() -> VehicleManager:
	var adapters = VehicleAdapters.new(
		self.driving,
		self.steering,
		self.distance,
		self.line
	)
	var state_manager = VehicleStateManager.new(self.initial_state, adapters)
	
	return VehicleManager.new(state_manager, adapters)
