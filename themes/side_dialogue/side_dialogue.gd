@tool
extends DialogicLayoutLayer

@export var dialogic_node_dialog_text_main: DialogicNode_DialogText
@export var dialogic_node_dialog_text_second: DialogicNode_DialogText
@export var dialogic_node_dialog_text_third: DialogicNode_DialogText
@export var simple_name_label: RichTextLabel


func _ready():
	show_textbox_owners()
	GlobalVar.update_textbox_identifier.connect(update_identifier)
	GlobalVar.update_textbox_identifier.connect(show_textbox_owners)
	Dialogic.Text.about_to_show_text.connect(speaker_exists)


func speaker_exists(_info):
	# Checks the character and chooses the correct one
	var speaker: DialogicCharacter = Dialogic.Text.get_current_speaker()
	
	if speaker!= null:
		for i in find_children("*", "DialogicNode_DialogText"):
			if speaker.get_character_name().to_lower() == i.identifier:
				i.enabled = true
				i.visible = true
			else:
				i.enabled = false


func update_identifier(speaker: String) -> void:
	var chara_arr: Array
	for dch_identifier in DialogicResourceUtil.get_character_directory():
		var _character:= (DialogicResourceUtil.get_character_resource(dch_identifier) as DialogicCharacter)
		chara_arr.append(_character.get_character_name().to_lower())
	# Remove the speaker, it is already assigned the main textbox.
	chara_arr.erase(speaker)
	
	for i in find_children("*", "DialogicNode_DialogText"):
		if i == dialogic_node_dialog_text_main:
			continue
		i.visible = false
		i.identifier = chara_arr.get(0)
		#print_rich("[b][u]Deleted[/u][/b] character: ",chara_arr.get(0),". --- ", i.name, " and [b]new id[/b] ", i.identifier)
		chara_arr.erase(chara_arr.get(0))
	
	# NOTE: Getting a dialogic character with only it's identifier
	simple_name_label.text = load(DialogicResourceUtil.get_character_directory()[speaker]).display_name
	dialogic_node_dialog_text_main.identifier = speaker
	
	for i in chara_arr:
		chara_arr.erase(i)


func show_textbox_owners(_speaker:=""):
	if %owners_vbox.get_child_count() > 0:
		for i in %owners_vbox.get_children():
			i.queue_free()
	
	for i in find_children("*", "DialogicNode_DialogText"):
		var label:= Label.new()
		label.text = i.name + ": " + i.identifier
		%owners_vbox.add_child(label)
