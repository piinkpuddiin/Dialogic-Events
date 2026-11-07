@tool
extends DialogicEvent
class_name DialogicImageMessageEvent

var speaker: String
var image: String
var timer: Timer

func _execute() -> void:
	GlobalVar.new_image_message.emit(image, speaker)
	# NOTE: Would like to add a pause here, so that the image doesn't 
	# just appear in auto mode...
	if !dialogic.Inputs.auto_advance.is_enabled():
		await dialogic.Inputs.dialogic_action
	finish()


#region INITIALIZE
################################################################################
# Set fixed settings of this event
func _init() -> void:
	event_name = "Image Message"
	event_category = "Custom"
	event_description = "Adds an image message to the chat."
	set_default_color('Color6')

func _get_icon() -> Resource:
	return load(this_folder.path_join('image_example.png'))
#endregion

#region SAVING/LOADING
################################################################################
func get_shortcode() -> String:
	return "image_message"

func get_shortcode_parameters() -> Dictionary:
	return {
		"speaker"		: {"property": "speaker", "default": ""},
		"image" 		: {"property": "image", "default": ""},
	}

#endregion


#region EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_label('From:')
	add_header_edit('speaker', ValueType.SINGLELINE_TEXT)
	add_header_label('Image:')
	add_header_edit('image', DialogicEvent.ValueType.FILE)

#endregion
