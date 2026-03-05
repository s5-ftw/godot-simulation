## Manages the vehicle autonomously, by executing states
## That changes with each others, which calls the proper
## adapters
class_name VehicleManager

var state_manager: VehicleStateManager
var adapters: VehicleAdapters
var _was_added: bool

func _init(
	manager: VehicleStateManager,
	adapters: VehicleAdapters
) -> void:
	self.state_manager = manager
	self.adapters = adapters
	self._was_added = false

## Assign a debug grid to each adapters that contains a "_bind_debug_ui" method.
func bind_debug_ui(container: GridContainer)-> void:
	print("Binding debug ui to vehicle")
	
	var properties = adapters.get_property_list()
	for property in properties:
		var property_name = property["name"]
		var member = adapters.get(property_name)

		if typeof(member) == TYPE_OBJECT and member != null:
			print("- ", property_name)
			if !member.has_method("_bind_debug_ui"):
				continue

			var config = member.get("config")
			if config == null:
				push_error("adapter with _bind_debug_ui has no config variable: ", property_name)
				continue

			if config.ui_debug != true:
				print("\t ui_debug in config not set to true")
				continue

			_add_debug_column_header(container)
			var grid_container = GridContainer.new()
			grid_container.custom_minimum_size = Vector2(10, 10)
			grid_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			member._bind_debug_ui(grid_container)
			container.add_child(grid_container)
			print("Debug UI created for: ", property_name)

func _add_debug_column_header(container: GridContainer) -> void:
	print("Adapter debug column has childrens")
	if self._was_added: return
	self._was_added = true
	
	# 1. Root is a PanelContainer (handles background AND sizing)
	var header_panel = PanelContainer.new()
	header_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	# 2. Create a StyleBox for background + padding
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.1, 0.75)
	# This is your "padding" inside the dark box
	style.set_content_margin_all(10) 
	header_panel.add_theme_stylebox_override("panel", style)
	
	# 3. Add the Label directly
	var label = Label.new()
	label.text = "Adapter debug"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	header_panel.add_child(label)
	container.add_child(header_panel)
	

## Executes the current state.
func execute():
	return self.state_manager.execute()

## Tells the vehicle to stop.
func stop():
	# NOT DONE
	return

## Tells the vehicle to start
func start():
	## Not done
	return
