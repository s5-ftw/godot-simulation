## Abstract (interface) for a vehicle builder
class_name VehicleBuilder
extends RefCounted

static func new_builder() -> VehicleBuilder:
	push_error("new_builder() must be implemented in the vehicle builder")
	return VehicleBuilder.new()

func build() -> VehicleManager:
	push_error("build() must be implemented in the vehicle builder")
	return
