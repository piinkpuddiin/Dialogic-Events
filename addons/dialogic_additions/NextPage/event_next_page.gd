@tool
extends DialogicEvent
class_name DialogicNextPageEvent

# Define properties of the event here

func _execute() -> void:
	GlobalVar.clear_list.emit()
	# This will execute when the event is reached
	finish() # called to continue with the next event


#region INITIALIZE
################################################################################
# Set fixed settings of this event
func _init() -> void:
	event_name = "Next Page"
	set_default_color('Color4')
	event_category = "Custom"

func _get_icon() -> Resource:
	return load(this_folder.path_join('book_page.png'))
#endregion

#region SAVING/LOADING
################################################################################
func get_shortcode() -> String:
	return "next_page"

func get_shortcode_parameters() -> Dictionary:
	return {
		#param_name 		: property_info
		#"my_parameter"		: {"property": "property", "default": "Default"},
	}

# You can alternatively overwrite these 3 functions: to_text(), from_text(), is_valid_event()
#endregion


#region EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_label('Next Page')
	pass

#endregion
