## Allows you to build a distance sensor in various ways for real implementations or debug scripts.
## Real implementations should only build from a config.
## Debug and tests implementations are free to build it any ways they want.
## Default config is used if none is provided.
class_name DistanceSensorBuilder
extends RefCounted

var _filter_type: String
var _adapter_type: String
var _passed_adapter: DistanceSensorAdapter
var _passed_filter: DistanceFilterStrategy
var _config: DistanceSensorConfig

static func new_builder() -> DistanceSensorBuilder:
	return DistanceSensorBuilder.new()

## When you only got the type. Fuck the config.
func with_filter_type(type: String) -> DistanceSensorBuilder:
	_filter_type = type
	return self

## When you only got the type. Fuck the config.
func with_adapter_type(type: String) -> DistanceSensorBuilder:
	_adapter_type = type
	return self
	
## When you already got an adapter you wanna use.
func with_adapter(adapter: DistanceSensorAdapter) -> DistanceSensorBuilder:
	_passed_adapter = adapter
	return self

## When you already got a filter you wanna use.
func with_filter(filter: DistanceFilterStrategy) -> DistanceSensorBuilder:
	_passed_filter = filter
	return self

## Build everything from a config object.
func from_config(config: DistanceSensorConfig) -> DistanceSensorBuilder:
	_config = config
	return self

func build() -> DistanceSensor:
	var adapter = null
	var filter = null
	
	if _config != null:
		adapter = DistanceSensorAdapterFactory.create(_config)
		filter = DistanceFilterStrategyFactory.create(_config)
	else:
		_config = DistanceSensorConfig.new()
	
	if _filter_type != null:
		_config.filter_type = _filter_type
		filter = DistanceFilterStrategyFactory.create(_config)
		
	if _adapter_type != null:
		_config.adapter_type = _adapter_type
		adapter = DistanceSensorAdapterFactory.create(_config)
	
	if _passed_adapter != null:
		adapter = _passed_adapter
		
	if _passed_filter != null:
		filter = _passed_filter
	
	return DistanceSensor.new(filter, adapter)
