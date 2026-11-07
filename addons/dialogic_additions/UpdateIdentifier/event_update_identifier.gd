@tool
extends DialogicEvent
class_name DialogicUpdateIdentifierEvent


func _execute() -> void:
	# NOTE: Get's the following event information.
	var next_speaker = Dialogic.current_timeline_events[Dialogic.current_event_idx+1].character_identifier
	GlobalVar.update_textbox_identifier.emit(next_speaker)
	finish()


#region INITIALIZE
################################################################################
# Set fixed settings of this event
func _init() -> void:
	event_description = "Update the main textbox identifier to the current speaker."
	set_default_color('Color3')
	event_name = "Update Identifier"
	event_category = "Custom"
	event_sorting_index = -1

func _get_icon() -> Resource:
	return load(this_folder.path_join('icon.svg'))
#endregion

#region SAVING/LOADING
################################################################################
func get_shortcode() -> String:
	return "update_identifier"

func get_shortcode_parameters() -> Dictionary:
	return {
		#param_name 		: property_info
		#"my_parameter"		: {"property": "property", "default": "Default"},
	}

#endregion


#region EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_label('Update Main Textbox Identifier')
#endregion
