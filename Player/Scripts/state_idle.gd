class_name State_Idle extends State

@onready var walk: State_Walk = $"../Walk"

func enter() -> void:
	player.updateAnimation("idle")
	pass
	
func exit() -> void:
	pass
	
func process(_delta: float) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	
	player.velocity = Vector2.ZERO
	return null

func physics(_delta: float) -> State:
	return null
	
func handled_input(_event: InputEvent) -> State:
	return null
