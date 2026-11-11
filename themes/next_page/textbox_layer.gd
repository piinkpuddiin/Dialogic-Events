@tool
extends DialogicLayoutLayer

@export var message_list: VBoxContainer
@export var dialogic_text: DialogicNode_DialogText

## Inspired by Dialogic2 test project.
## https://github.com/dialogic-godot/test-project

var last_text := ""

func _ready() -> void:
	# NOTE: Dialogic isn't ready, so we have to wait for it's ready signal to be done.
	#await Dialogic.ready
	dialogic_text.started_revealing_text.connect(reveal_text)
	dialogic_text.continued_revealing_text.connect(continue_reveal)
	dialogic_text.finished_revealing_text.connect(finish_reveal)
	GlobalVar.clear_list.connect(clear_messages)

func reveal_text() -> void:
	dialogic_text.show()

func continue_reveal(_new_character: String) -> void:
	recolor_messages()

func finish_reveal() -> void:
	last_text = dialogic_text.text
	
	if last_text.is_empty():
		return
	dialogic_text.hide()
	add_message(last_text)

func add_message(_text:String) -> void:
	var text_node = RichTextLabel.new()
	
	var font: Font = dialogic_text.get_theme_font("normal_font", 'RichtTextLabel')
	# NOTE: Check the font size matches with the textbox font size
	var string_size: Vector2 = font.get_string_size(_text, HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT, -1, 32)
	var max_width: int = int(message_list.size.x)
	var smallest_line_amount := -1
	
	for i in range(1,10):
		if string_size.x/i+100 > max_width: 
			# The number controls the maximum amount of space
			# horizontally between each paragraph.
			continue
		else:
			smallest_line_amount = i
			break
	
	text_node.bbcode_enabled = true
	# WARNING
	text_node.custom_minimum_size = Vector2(300, smallest_line_amount * string_size.y) 
	text_node.text = _text
	text_node.add_theme_font_size_override("normal_font_size", 32)
	
	message_list.add_child(text_node)
	message_list.move_child(dialogic_text,-1)

## Makes the previous messages a lighter color.
func recolor_messages() -> void:
	for i in message_list.get_children():
		if i != dialogic_text:
			i.modulate = Color(1.0, 1.0, 1.0, 0.392)

## Called to clear the previous messages in the message list.
func clear_messages():
	for i in message_list.get_children():
		if i != dialogic_text:
			i.queue_free()
