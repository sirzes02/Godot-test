class_name EnemyStateMachine extends Node

var states: Array[State]
var prev_state: State
var current_state: State

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass 

func _process(delta: float) -> void:
	changeState(current_state.process(delta))
	pass
	
func _physics_process(delta: float) -> void:
	changeState(current_state.physics(delta))
	pass
	
func initialize(_enemy: Enemy) -> void:
	states = []
	
	for child in get_children():
		if child is State:
			states.append(child)
	
	for state in states:
		state.enemy = _enemy
		state.enemy_state_machine = self
		state.init()
		
	if states.size() > 0:
		changeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT
	
	pass

func changeState(new_state: State) -> void:
	if new_state == null || new_state == current_state:
		return
		
	if current_state:
		current_state.exit()
		
	prev_state = current_state
	current_state = new_state
	current_state.enter()
