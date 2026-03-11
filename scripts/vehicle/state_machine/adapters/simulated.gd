## State Machine adapter that displays the current vehicle state
class_name SimulatedStateMachine
extends Node

var state_manager: VehicleStateManager
var debug_timer: Timer

var _current_state_label: Label = Label.new()

## Initialize the adapter with a state manager reference
func set_state_manager(manager: VehicleStateManager) -> void:
	self.state_manager = manager

## Setup the debug UI following the pattern from distance sensor adapter
func _bind_debug_ui(container: GridContainer) -> void:
	## Clear existing UI
	for child in container.get_children():
		child.queue_free()
	
	## Setup for centered text
	container.columns = 1
	
	_state_debug_ui_setup(container)

	## UI update timer, to avoid having to deal with _process(delta)
	debug_timer = Timer.new()
	debug_timer.wait_time = 0.05 # 20 FPS UI refresh
	debug_timer.autostart = true
	debug_timer.timeout.connect(self._ui_update)
	container.add_child(debug_timer)

## Setup the state display UI
func _state_debug_ui_setup(parent_container: GridContainer) -> void:
	sub_header(parent_container, "vehicle state")
	
	var container = GridContainer.new()
	container.columns = 1
	container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	_current_state_label = Label.new()
	_current_state_label.text = "loading..."
	_current_state_label.add_theme_color_override("font_color", Color.CYAN)
	_current_state_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_current_state_label.add_theme_font_size_override("font_size", 16)
	_current_state_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.add_child(_current_state_label)
	
	parent_container.add_child(container)

## Avoids code duplication. Centered text indicating the debug section.
func sub_header(parent_container: GridContainer, text: String) -> void:
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 12)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color.DARK_GRAY)
	parent_container.add_child(label)

## Update the UI every x fps
func _ui_update() -> void:
	if state_manager == null:
		_current_state_label.text = "no manager"
		return
	
	var current_state = state_manager.current()
	_current_state_label.text = current_state
