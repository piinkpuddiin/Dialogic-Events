@tool
extends DialogicEvent
class_name DialogicEmojiReactionEvent

var emoji: String
var amount: int = 1 # How many users liked the text
var time: int # How long until the emoji appears

func _execute() -> void:
	if time == 0:
		# Randomize the time if it's empty
		time = randi_range(0.5, 2.5)
		print("No time set, new time: ", time)
	GlobalVar.emoji_react.emit(emoji, time, amount)
	finish()


#region INITIALIZE
################################################################################
# Set fixed settings of this event
func _init() -> void:
	event_name = "Emoji Reaction"
	event_category = "Custom"
	event_description = "Adds an reaction to the message in the chat."
	set_default_color('Color3')

func _get_icon() -> Resource:
	return load(this_folder.path_join('smiley_icon.png'))
#endregion

#region SAVING/LOADING
################################################################################
func get_shortcode() -> String:
	return "emoji_reaction"

func get_shortcode_parameters() -> Dictionary:
	return {
		#param_name 		: property_info
		"emoji"				: {"property": "emoji", "default": "💖"},
		"time"				: {"property": "time", "default": "0"},
		"amount"			: {"property": "amount", "default": "1"},
	}

# You can alternatively overwrite these 3 functions: to_text(), from_text(), is_valid_event()
#endregion


#region EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_label('Emoji:')
	add_header_edit('emoji', ValueType.SINGLELINE_TEXT)
	add_header_label('Time:')
	add_header_edit('time', DialogicEvent.ValueType.NUMBER)
	add_header_label('Amount:')
	add_header_edit('amount', DialogicEvent.ValueType.NUMBER)

#endregion
