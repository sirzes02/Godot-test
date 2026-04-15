@tool
class_name QuestNode extends Node2D

@export var linked_quest: Quest = null:
	set = _set_quest
@export var quest_step: int = 0:
	set = _set_step
@export var quest_complete: bool = false:
	set = _set_complete
	
@export_category("Information Only")
var settings_summary: String

func _set_quest(_v: Quest) -> void:
	linked_quest = _v
	quest_step = 0
	update_summary()
	pass

func _set_step(_v: int) -> void:
	quest_step = clamp(_v, 0, get_step_count())
	update_summary()
	pass
	
func get_step_count() -> int:
	if linked_quest == null:
		return 0
	else:
		return linked_quest.steps.size()

func _set_complete(_v: bool) -> void:
	quest_complete = _v
	update_summary()
	pass
 
func update_summary() -> void:
	settings_summary = "UPDATE QUEST:\nQuest: " + linked_quest.title + "\n"
	settings_summary += "Step: " + str(quest_step) + " - " + get_step() + "\n"
	settings_summary += "Complete: " + str(quest_complete)
	notify_property_list_changed()
	pass
	
func get_step() -> String:
	if quest_step != 0 and quest_step <= get_step_count():
		return linked_quest.steps[quest_step - 1]
	else:
		return "N/A"
		
func _get_property_list():
	return [
		{
			"name": "Settings Summary",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_MULTILINE_TEXT,
			"usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY
		}
	]

func _get(property):
	if property == "Settings Summary":
		return settings_summary
		
func _set(_property, _value):
	return false
