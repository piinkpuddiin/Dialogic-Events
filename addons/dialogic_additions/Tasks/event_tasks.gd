@tool
extends DialogicEvent
class_name DialogicTasksEvent

var task_name: String
var task_mssg: String
var task_meta: bool

func _execute() -> void:
	GlobalVar.check_task.emit(task_name, task_mssg, task_meta)
	finish()


#region INITIALIZE
################################################################################
# Set fixed settings of this event
func _init() -> void:
	event_description = "Sets or marks a task as completed."
	set_default_color('Color4')
	event_name = "Tasks"
	event_category = "Custom"

func _get_icon() -> Resource:
	return load(this_folder.path_join('checklist.png'))
#endregion

#region SAVING/LOADING
################################################################################
func get_shortcode() -> String:
	return "tasks"

func get_shortcode_parameters() -> Dictionary:
	return {
		"task_name" 		: {"property": "task_name", 	"default": "Task"},
		"task_message" 		: {"property": "task_mssg", 	"default": "Task message."},
		"task_meta" 		: {"property": "task_meta", 	"default": false},
	}

# You can alternatively overwrite these 3 functions: to_text(), from_text(), is_valid_event()
#endregion


#region EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_label('Task Name')
	add_header_edit('task_name', ValueType.SINGLELINE_TEXT)
	add_header_label('Task Message')
	add_header_edit('task_mssg', ValueType.SINGLELINE_TEXT)
	add_header_label('Completed')
	add_header_edit('task_meta', ValueType.BOOL)

#endregion
