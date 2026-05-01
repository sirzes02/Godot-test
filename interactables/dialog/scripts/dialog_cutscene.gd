@tool
@icon("res://gui/dialog_system/icons/cutscene_bubble.svg")
class_name DialogCutscene extends DialogItem

signal finished

enum Mode {PARRALLEL, SEQUENTIAL}

@export var playback_mode: Mode = Mode.SEQUENTIAL

var actions: Array[CutsceneAction] = []
var actions_finished_count: int = 0

func _ready() -> void:
	gather_actions()
	pass

func gather_actions() -> void:
	for c in get_children():
		if c is CutsceneAction:
			actions.append(c)
			
			if not Engine.is_editor_hint():
				c.finished.connect(_on_action_finished)
	
	pass
	
func play() -> void:
	if Engine.is_editor_hint():
		return
		
	if actions.size() == 0:
		await get_tree().process_frame
		finished.emit()
	elif playback_mode == Mode.SEQUENTIAL:
		actions[0].play()
	else:
		for a in actions:
			a.play()
	
	pass

func _on_action_finished() -> void:
	actions_finished_count += 1
	
	if actions_finished_count >= actions.size():
		finished.emit()
	elif playback_mode == Mode.SEQUENTIAL:
		actions[actions_finished_count].play()
	
	pass
