@tool
@icon("res://gui/dialog_system/icons/question_bubble.svg")
class_name DialogChoice extends DialogItem

var dialog_branches: Array[DialogBranch]

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	for child in get_children():
		if child is DialogBranch:
			dialog_branches.append(child)

func _get_configuration_warnings() -> PackedStringArray:
	if !_check_for_dialog_item():
		return ["Requieres at least one DialogItem node."]
	else:
		return []

func _check_for_dialog_item() -> bool:
	var _count: int = 0
	
	for child in get_children():
		if child is DialogBranch:
			_count += 1
			
			if _count > 1:
				return true
	
	return false
