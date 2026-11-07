extends Control


func _ready() -> void:
	GlobalVar.end_timeline.connect(show_button)
	#GlobalVar.end_game.connect(show_button)

func show_button():
	%start_button.show()

func _on_start_button_pressed() -> void:
	GlobalVar.start_game.emit()
	GlobalVar.start_timeline.emit("res://placeholder/timeline_simple.dtl")
	%start_button.hide()
