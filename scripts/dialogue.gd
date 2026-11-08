extends Control

@export var events_menu: Control
@export_enum("GROUP_MESSAGE", "NEXT_PAGE", "UPDATE_ID", "STORY_PROGRESS") var type = "UPDATE_ID"

var textbox_themes:= {
	"group_message": "res://themes/group_messages/smartphone.tres",
	"next_page": "res://themes/next_page/moon_style.tres",
	"update_id": "res://themes/side_dialogue/side_dialogue.tres",
	"story_progress": "res://themes/simple/simple.tres",
}
var timeline: String

func _ready() -> void:
	#dialog_timeline = Dialogic.preload_timeline(timeline)
	# We start the dialogue with the start button.
	GlobalVar.start_timeline.connect(start_dialogue)
	# We go back to the main menu once the timeline is finshed.
	Dialogic.timeline_ended.connect(dialogue_ended)


func start_dialogue() -> void:
	events_menu.hide()
	# Check if a dialog is already running
	if Dialogic.current_timeline != null:
		return
	
	if type == "GROUP_MESSAGE":
		Dialogic.Settings.text_speed = 0.0
	else:
		Dialogic.Settings.text_speed = 0.1
	
	if type == "UPDATE_ID":
		var bg = load("res://scenes/side_dialogue/bg.tscn").instantiate()
		get_parent().add_child(bg)
	if type == "STORY_PROGRESS":
		var progress_bar = load("res://scenes/story_progress/story_progress_bar.tscn").instantiate()
		get_parent().add_child(progress_bar)
	
	# Set the style
	timeline = "res://dialogue/" + type.to_lower() + "_timeline.dtl"
	Dialogic.Styles.load_style(textbox_themes[type.to_lower()])
	
	Dialogic.start_timeline(timeline)


func dialogue_ended() -> void:
	events_menu.show()
	if type == "UPDATE_ID" or type == "STORY_PROGRESS":
		get_parent().get_child(-1).queue_free()
