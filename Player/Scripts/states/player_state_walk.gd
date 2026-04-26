class_name State_Walk extends State

@export var move_speed: float = 100.0

@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"
@onready var dash: State = $"../Dash"

func enter() -> void:
	player.updateAnimation("walk")
	pass
	
func exit() -> void:
	pass
	
func process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
		
	player.velocity = player.direction * move_speed
	
	if player.setDirection():
		player.updateAnimation("walk")
	
	return null

func physics(_delta: float) -> State:
	return null
	
	
func handled_input(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	elif _event.is_action_pressed("interact"):
		PlayerManager.interact()
	elif _event.is_action_pressed("dash"):
		return dash
	
	return null
