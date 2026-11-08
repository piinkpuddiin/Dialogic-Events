extends Control

@export var progress_bar: ProgressBar

func _ready() -> void:
	GlobalVar.story_progressed.connect(add_progress)

func add_progress(value: int) -> void:
	progress_bar.value += value
