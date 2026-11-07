extends Control

@export var bg_color: ColorRect
@export var bg_texture: TextureRect
@export var top_portrait: Control
@export var bottom_portrait: Control

@export var portait_text_bottom: TextureRect
@export var portrait_text_top: TextureRect


func _ready():
	top_portrait.hide()
	bottom_portrait.hide()
	GlobalVar.update_textbox_identifier.connect(speaker_exists)
	Dialogic.timeline_ended.connect(hide_speaker)


func speaker_exists(speaker):
	top_portrait.show()
	bottom_portrait.show()
	
	if speaker!= null:
		var image_path_top = "res://images/mini-portrait/%s.png" % speaker.to_lower()
		var image_path_bottom = "res://images/mini-portrait/group_no_%s.png" % speaker.to_lower()
		portrait_text_top.texture = load(image_path_top)
		portait_text_bottom.texture = load(image_path_bottom)


func hide_speaker() -> void:
	top_portrait.hide()
	bottom_portrait.hide()
