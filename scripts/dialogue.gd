extends Control

#@export var main: Node
#@export var main_menu: Control
#@export var game_layer: CanvasLayer
#@export var timeline: DialogicTimeline
#@export var text_style:= "res://themes/textbox_styles/group_voice_call/group_call_static.tres"
@export_enum("GROUP_MESSAGE", "NEXT_PAGE", "UPDATE_ID") var type = "UPDATE_ID"

var textbox_themes:= {
	"group_message": "res://themes/group_messages/smartphone.tres",
	"next_page": "res://themes/next_page/moon_style.tres",
	"update_id": "res://themes/side_dialogue/side_dialogue.tres",
}

var timeline

func _ready() -> void:
	#dialog_timeline = Dialogic.preload_timeline(timeline)
	# We start the dialogue with the start button.
	GlobalVar.start_timeline.connect(start_dialogue)
	# We go back to the main menu once the timeline is finshed.
	Dialogic.timeline_ended.connect(dialogue_ended)


func start_dialogue() -> void:
	%EventsMenu.hide()
	# Check if a dialog is already running
	if Dialogic.current_timeline != null:
		return
	
	Dialogic.Settings.text_speed = 0.1
	
	# Set the style
	if type == "GROUP_MESSAGE":
		Dialogic.Settings.text_speed = 0.0
		timeline = "res://dialogue/group_chat_timeline.dtl"
		Dialogic.Styles.load_style(textbox_themes['group_message'])
	elif type == "NEXT_PAGE":
		timeline = "res://dialogue/next_page_timeline.dtl"
		Dialogic.Styles.load_style(textbox_themes['next_page'])
	elif type == "UPDATE_ID":
		timeline = "res://dialogue/update_identifier_timeline.dtl"
		Dialogic.Styles.load_style(textbox_themes['update_id'])
	
	Dialogic.start_timeline(timeline)
	print("The dialogue started!")


func dialogue_ended() -> void:
	%EventsMenu.show()
	print("The dialogue ended...")
