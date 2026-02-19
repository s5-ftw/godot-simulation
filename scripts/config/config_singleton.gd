# ConfigLoader.gd
extends Node
class_name ConfigSingleton

static var _instance: ConfigSingleton = null
static var _config: Dictionary = {}
static var _parser: YAMLParser
static var config: VehicleConfig

static func get_instance() -> ConfigSingleton:
	print("Config file singleton instanciating...")
	if _instance == null:
		_instance = ConfigSingleton.new()
		_parser = YAMLParser.new()
		_instance._load_config()
	return _instance

func _load_config(path: String = "res://config.yaml") -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open config file: %s" % path)
		return
	
	var content := file.get_as_text()
	file.close()
	
	# Requires a YAML parser plugin for Godot
	# Example assumes a global `YAML` class with `parse` method
	_config = _parser.parse(content)
	print(_config)
	
	var builder := VehicleConfigBuilder.new_builder()
	builder.with_config(_config)
	self.config = builder.build()
