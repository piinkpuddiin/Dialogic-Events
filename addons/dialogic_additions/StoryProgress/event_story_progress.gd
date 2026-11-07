@tool
extends DialogicEvent
class_name DialogicStoryProgressEvent

var amount: int

func _execute() -> void:
	GlobalVar.story_progress += amount
	GlobalVar.dialogue_label = Dialogic.Jump.get_last_label_identifier()
	GlobalVar.story_progressed.emit()
	finish()


#region INITIALIZE
################################################################################
# Set fixed settings of this event
func _init() -> void:
	event_description = "Adds the given amount to the story progress variable."
	set_default_color('Color4')
	event_name = "Story Progress"
	event_category = "Custom"

func _get_icon() -> Resource:
	return load(this_folder.path_join('percent_progress.png'))

#endregion

#region SAVING/LOADING
################################################################################
func get_shortcode() -> String:
	return "story_progress"

func get_shortcode_parameters() -> Dictionary:
	return {
		"amount" 			: {"property": "amount", 	"default": 0},
	}

#endregion


#region EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_label('Story Progress')
	add_header_edit('amount', ValueType.NUMBER)
#endregion
