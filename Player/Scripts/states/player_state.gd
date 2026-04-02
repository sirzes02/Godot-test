class_name State extends Node

static var player: Player
static var player_state_machine: PlayerStateMachine

func _ready() -> void:
	pass # Replace with function body.
	
func init() -> void:
	pass

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process(_delta: float) -> State:
	return null

func physics(_delta: float) -> State:
	return null
	
func handled_input(_event: InputEvent) -> State:
	return null
