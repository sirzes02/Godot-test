extends Node

signal quest_updated(q: Quest)

const QUEST_DATA_LOCATION: String = "res://quests/"

var quests: Array[Quest]
var current_quests: Array

func _ready() -> void:
	gather_quest_data()
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		# update_quest( "Recover Lost Magical Flute", "", true )
		# update_quest( "short quest", "", true )
		# update_quest( "long quest", "step 1" )
		# update_quest( "long quest", "step 2" )
		pass
	
	pass
	
func gather_quest_data() -> void:
	var quest_files: PackedStringArray = DirAccess.get_files_at(QUEST_DATA_LOCATION)
	quests.clear()
	
	for quest_file in quest_files:
		quests.append(load(QUEST_DATA_LOCATION + "/" + quest_file))
		pass
		
	pass
 
func update_quest(_title: String, _completed_step: String, _is_complete: bool = false) -> void:
	var quest_index: int = get_quest_index_by_title(_title)
	
	if quest_index == -1:
		var new_quest: Dictionary = {
			title = _title,
			is_complete = _is_complete,
			completed_steps = []
		}
		
		if _completed_step != "":
			new_quest.completed_steps.append(_completed_step)
			
		current_quests.append(new_quest)
		quest_updated.emit(new_quest)
		
		pass
	else:
		var quest = current_quests[quest_index]
		
		if _completed_step != "" and not quest.completed_steps.has(_completed_step):
			quest.completed_steps.append(_completed_step)
			pass
		
		if not quest.is_complete:
			quest.is_complete = _is_complete
		
		quest_updated.emit(quest)
		
		if quest.is_complete:
			disperse_quest_rewards(find_quest_by_title(_title))
	pass

func disperse_quest_rewards(_q: Quest) -> void:
	PlayerManager.reward_xp(_q.reward_xp)
	
	for i in _q.reward_items:
		PlayerManager.INVENTORY_DATA.add_item(i.item, i.quantity)
	pass

func find_quest(_quest: Quest) -> Dictionary:
	for quest in current_quests:
		if quest.title.to_lower() == _quest.title.to_lower():
			return quest
	
	return {title = "Not Found", is_complete = false, completed_steps = ['']}

func find_quest_by_title(_title: String) -> Quest:
	for quest in quests:
		if quest.title.to_lower() == _title.to_lower():
			return quest
	
	return null

func get_quest_index_by_title(_title: String) -> int:
	for i in current_quests.size():
		if current_quests[i].title.to_lower() == _title.to_lower():
			return i
	
	return -1

func sort_quests() -> void:
	var active_quests: Array = []
	var completed_quests: Array = []
	
	for q in current_quests:
		if q.is_complete:
			completed_quests.append(q)
		else:
			active_quests.append(q)
			
	active_quests.sort_custom(sort_quests_ascending)
	completed_quests.sort_custom(sort_quests_ascending)
	current_quests = active_quests
	current_quests.append_array(completed_quests)
	pass

func sort_quests_ascending(a, b) -> bool:
	if a.title < b.title:
		return true
		
	return false
