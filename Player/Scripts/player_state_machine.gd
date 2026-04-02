class_name PlayerStateMachine extends Node

var states: Array[State]
var prev_state: State
var current_state: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	changeState(current_state.process(delta))
	pass
	
func _physic_process(delta: float) -> void:
	changeState(current_state.physics(delta))
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	changeState(current_state.handled_input(event))
	pass

func initialize(_player: Player) -> void:
	states = []
	
	for child in get_children():
		if child is State:
			states.append(child)
	
	if states.size() == 0:
		return
	
	states[0].player = _player
	states[0].player_state_machine = self
	
	for state in states:
		state.init()
	
	changeState(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT

func changeState(new_state: State) -> void:
	if new_state == null || new_state == current_state:
		return
		
	if current_state:
		current_state.exit()
		
	prev_state = current_state
	current_state = new_state
	current_state.enter()
