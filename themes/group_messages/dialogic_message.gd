@tool
extends DialogicLayoutLayer
enum Alignments {LEFT, CENTER, RIGHT}

@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var dialog_text = %DialogicNode_DialogText
@onready var scroll_container = %ScrollContainer
@onready var scroll_text_bar = dialog_text.get_v_scroll_bar()
@onready var scroll_container_bar = scroll_container.get_v_scroll_bar()
@onready var message_list = %MessageList
@onready var scroll_container_child = scroll_container.get_child(0)
@onready var scroll_v_max = max(0, message_list.size.y)


@export_category("Scenes")
@export_file('*.extension') var message_scene: String = "res://themes/group_messages/new_message_group_chat.tscn"
@export_file('*.extension') var message_icon: String = "res://scenes/group_messages/user_icon.tscn"
#@export_file('*.extension') var user_icon: String = "res://gui/icons/profiles/pinkicon.png"
@export_file('*.extension') var image_message: String = "res://scenes/group_messages/image_message.tscn"
@export_file('*.extension') var reaction_label: String = "res://scenes/group_messages/emoji_reaction.tscn"

@export_category("Custom")
@export var player_name: String = "mc"
@export var group_users: Dictionary[String, Color] = {
	"npc": Color(0.875, 0.318, 0.318, 1.0),
	"n": Color(0.279, 0.469, 1.0, 1.0),
	"npc2": Color(0.835, 1.0, 0.051, 1.0),
}
@export var npc2_color: Color = Color(0.835, 1.0, 0.051, 1.0)
## The space between messages when a different person speaks.
@export var additional_message_space:= 14
@export var min_reaction_time:= 0.1
@export var max_reaction_time:= .9

## These properties store information on the last text,
## so that a textbox that looks the same can be added, when the next text is revealed.
var last_text := ""
var last_text_speaker: DialogicCharacter = null
var previous_speaker: String = ""
var last_text_time := ""
## Change to true if player speaks first, else to false.
var new_message:= false


func _ready() -> void:
	GlobalVar.new_image_message.connect(add_image_message)
	GlobalVar.emoji_react.connect(add_reaction)

func _apply_export_overrides() -> void:
	if !is_inside_tree():
		await ready

func _add_space():
	var message_space: Control = Control.new()
	message_space.custom_minimum_size.y = additional_message_space
	message_list.add_child(message_space)

func group_user_array() -> Array[String]:
	var group_array: Array[String]
	for i in group_users.keys():
		group_array.append(i)
	return group_array


#region VERTICAL layout
## Handle UI things, when a new text starts revealing
func _on_dialogic_node_dialog_text_started_revealing_text() -> void:
	#Dialogic.Text._letter_speed_absolute = 0.0
	#Dialogic.Text._update_user_speed(0)
	dialog_text.hide()
	# update the size of the box
	dialog_text.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	
	# update the little time-label of the box
	var time := Time.get_datetime_dict_from_system()
	%time_label.text = str(time.hour)+":"+str(time.minute)

## Store all info about the textbox, when it finishes revealing.
## Also add a new textbox with all that info.
func _on_dialogic_node_dialog_text_finished_revealing_text() -> void:
	last_text = dialog_text.text
	last_text_speaker = Dialogic.Text.get_current_speaker()
	last_text_time = %time_label.text
	
	if last_text.is_empty():
		return
	
	dialog_text.hide()
	add_message(last_text, last_text_speaker.get_character_name(), last_text_time)


########################################################################################################
########################################################################################################

## Adds a new textbox.
## These textboxes are purely visual and not DialogicNode_DialogText nodes!
## Only the newest messages appears on the %DialogicNode_DialogText node.
func add_message(text:String, speaker_name:String, _time:String) -> void:
	var message: RichTextLabel = load(message_scene).instantiate()
	var icon: Panel = load(message_icon).instantiate()
	var hbox: HBoxContainer = HBoxContainer.new()
	var current_speaker:= speaker_name
	
	# If a different person speaks, we add additional space between the messages.
	if !previous_speaker == current_speaker:
		_add_space()
	
	hbox.size = Vector2(40, 40)
	hbox.add_theme_constant_override('separation', 13)
	
	hbox.add_child(message)
	hbox.add_child(icon)
	message_list.add_child(hbox)
	audio_stream_player.play()
	#ATTENTION: always adjust depending on how many items there are in list
	message_list.move_child(hbox, get_index()-1) 
	
	hbox.size.x = 350
	message.position.x = 30
	icon.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	icon.custom_minimum_size = Vector2i(50, 50)
	
	if Dialogic.Text.get_current_speaker():
		match Dialogic.Text.get_current_speaker().get_character_name():
			player_name:
				hbox.move_child(icon, -1)
				
				hbox.alignment = BoxContainer.ALIGNMENT_END
				message.grow_horizontal = Control.GROW_DIRECTION_END
				message.horizontal_alignment= HorizontalAlignment.HORIZONTAL_ALIGNMENT_RIGHT
				
				if !previous_speaker == current_speaker:
					var icon_profile = icon.get_node("TextureRect")
					icon_profile.modulate = Color("bdff97ff")
					#print("This is the mc speaking, so the same speaker needs to be true to work")
				elif previous_speaker == current_speaker:
					icon.modulate = Color(0.0, 0.0, 0.0, 0.0)
					#print("This is still the mc speaking, we hide the icon")
					if message_list.get_child(-2).has_meta('reaction'): 
						print("The above message has a reaction!")
					
				message.text = text
			
			# NOTE: Make usernames match with pfp for ease
			_:
				hbox.move_child(icon, 0)
				
				hbox.alignment = BoxContainer.ALIGNMENT_BEGIN
				message.grow_horizontal = Control.GROW_DIRECTION_BEGIN
				message.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT
				message.vertical_alignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER
				
				if !previous_speaker == current_speaker:
					#print("The speaker is not the same as the previous one. Show the icon.")
					var icon_profile = icon.get_node("TextureRect")
					for i in group_users.keys():
						if i == current_speaker:
							icon_profile.modulate = group_users[i]
				elif previous_speaker == current_speaker:
					#print("The speaker is still the same, hide the icon.")
					icon.modulate = Color(0.0, 0.0, 0.0, 0.0)
				message.text = text
	
	GlobalVar.new_phone_message.emit(message.get_content_width(), message.get_content_height(), current_speaker, previous_speaker)
	
	message.vertical_alignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER
	message.set_meta('speaker', speaker_name)
	previous_speaker = current_speaker
	
	await get_tree().process_frame
	scroll_container.ensure_control_visible(hbox)
#endregion


#region IMAGES
func add_reaction(reaction, amount):
	var message = message_list.get_child(-1)
	var reaction_message: RichTextLabel = load(reaction_label).instantiate()
	var extra_space = Control.new()
	
	reaction_message.text = reaction
	message.set_meta('reaction', true)
	await get_tree().create_timer(amount).timeout
	
	if message.get_child(0).has_meta('speaker'):
		if message.get_child(0).get_meta('speaker') == "mc":
			reaction_message.offset_transform_position = Vector2(35,22)
			reaction_message.grow_horizontal = Control.GROW_DIRECTION_END
			await get_tree().create_timer(randf_range(min_reaction_time, max_reaction_time)).timeout
			message.add_child(reaction_message)
			message.move_child(reaction_message, 0)
			message_list.add_child(extra_space)
	else:
		reaction_message.offset_transform_position = Vector2(-37,22)
		reaction_message.grow_horizontal = Control.GROW_DIRECTION_BEGIN
		await get_tree().create_timer(randf_range(min_reaction_time, max_reaction_time)).timeout
		message.add_child(reaction_message)
		message_list.add_child(extra_space)
	
	extra_space.custom_minimum_size.y = 8
	extra_space.name = "extra_space"
	
	message_list.move_child(extra_space, message.get_index()+1)
	await get_tree().process_frame
	scroll_container.ensure_control_visible(message_list.get_child(-1))


## Adds an image message (a custom scene)
func add_image_message(image:String, speaker:String) -> void:
	var message: Control = load(image_message).instantiate()
	var icon: Panel = load(message_icon).instantiate()
	var hbox: HBoxContainer = HBoxContainer.new()
	var current_speaker:= speaker
	
	hbox.add_theme_constant_override('separation', 13)
	hbox.add_child(message)
	hbox.add_child(icon)
	
	icon.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	icon.custom_minimum_size = Vector2i(50, 50)
	
	# If a different person speaks, we add additional space between the messages.
	if !previous_speaker == current_speaker:
		_add_space()
	
	if Dialogic.Text.get_current_speaker():
		match speaker:
			player_name:
				hbox.move_child(icon, -1)
				
				hbox.alignment = BoxContainer.ALIGNMENT_END
				hbox.grow_horizontal = Control.GROW_DIRECTION_END
				
				if !previous_speaker == current_speaker:
					var icon_profile = icon.get_node("TextureRect")
					icon_profile.modulate = Color("bdff97ff")
				elif previous_speaker == current_speaker:
					icon.modulate = Color(0.0, 0.0, 0.0, 0.0)
			_:
				hbox.move_child(icon, 0)
				
				hbox.alignment = BoxContainer.ALIGNMENT_BEGIN
				hbox.grow_horizontal = Control.GROW_DIRECTION_BEGIN
				
				if !previous_speaker == current_speaker:
					var icon_profile = icon.get_node("TextureRect")
					for i in group_users.keys():
						if i == current_speaker:
							icon_profile.modulate = group_users[i]
				elif previous_speaker == current_speaker:
					icon.modulate = Color(0.0, 0.0, 0.0, 0.0)
	
	message.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	message.position = Vector2(200,50)
	message.get_node('Image').texture = load(image)
	message.set_meta('speaker', speaker)
	message.custom_minimum_size.y = message.get_node('Image').get_size().y / 2
	message.custom_minimum_size.x = message.get_node('Image').get_size().x
	
	message_list.add_child(hbox)
	audio_stream_player.play()
	message_list.move_child(hbox, get_index()-1)
	
	await get_tree().process_frame
	scroll_container.ensure_control_visible(hbox)
#endregion


func _on_skip_button_toggled(toggled_on: bool) -> void:
	Dialogic.Inputs.auto_skip.enabled = toggled_on


func _on_auto_button_toggled(toggled_on: bool) -> void:
	Dialogic.Inputs.auto_advance.enabled_forced = toggled_on
