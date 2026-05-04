class_name State_Cutscene extends State

@onready var idle: State = $"../Idle"

func init() -> void:
	DialogSystem.started.connect(_on_dialog_started)
	DialogSystem.finished.connect(_on_dialog_finished)
	pass

func enter() -> void:
	player.update_animation("idle")
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	pass
	
func exit() -> void:
	player.process_mode = Node.PROCESS_MODE_INHERIT
	pass
	
func process(_delta: float) -> State:
	player.velocity = Vector2.ZERO
	return null

func physics(_delta: float) -> State:
	return null
	
func handled_input(_event: InputEvent) -> State:
	return null

func _on_dialog_started() -> void:
	player_state_machine.changeState(self )
	pass

func _on_dialog_finished() -> void:
	player_state_machine.changeState(idle)
	pass
