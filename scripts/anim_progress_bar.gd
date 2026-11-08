extends ProgressBar

var tween: Tween

func _ready() -> void:
	GlobalVar.story_progressed.connect(animate_progress)


func animate_progress(new_value: float) -> void:
	if tween:
		tween.kill()
	#print("The value: ", value, ".//The new value: ", new_value)
	
	tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "value", value, .01)
	tween.tween_property(self, "value", value + new_value, 2.0)
