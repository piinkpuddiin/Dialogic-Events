extends Node


func _on_phone_events_button_pressed() -> void:
	%Dialogue.type = "GROUP_MESSAGE"
	GlobalVar.start_timeline.emit()


func _on_next_page_button_pressed() -> void:
	%Dialogue.type = "NEXT_PAGE"
	GlobalVar.start_timeline.emit()


func _on_update_textbox_button_pressed() -> void:
	%Dialogue.type = "UPDATE_ID"
	GlobalVar.start_timeline.emit()
