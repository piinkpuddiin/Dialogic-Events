@tool
extends Node

signal start_timeline

## EMOJI REACTION
signal emoji_react


## IMAGE MESSAGE
signal new_image_message


## GROUP MESSAGES
signal new_phone_message


## UPDATE TEXTBOX IDENTIFIER
signal update_textbox_identifier


## NEXT PAGE
signal clear_list


## STORY PROGRESS
signal story_progressed
var story_progress: int = 0
var dialogue_label: String
