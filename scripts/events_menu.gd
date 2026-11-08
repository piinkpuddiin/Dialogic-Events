extends Node

@export var dialogue: Control

func _on_phone_events_button_pressed() -> void:
	dialogue.type = "GROUP_MESSAGE"
	GlobalVar.start_timeline.emit()


func _on_next_page_button_pressed() -> void:
	dialogue.type = "NEXT_PAGE"
	GlobalVar.start_timeline.emit()


func _on_update_textbox_button_pressed() -> void:
	dialogue.type = "UPDATE_ID"
	GlobalVar.start_timeline.emit()


func _on_story_progress_button_pressed() -> void:
	dialogue.type = "STORY_PROGRESS"
	GlobalVar.start_timeline.emit()
