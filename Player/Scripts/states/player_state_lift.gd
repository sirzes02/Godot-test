class_name State_Lift extends State

@export var lift_audio: AudioStream

@onready var carry: Node = $"../Carry"

var start_animation_late: bool= false

func enter() -> void:
	player.updateAnimation("lift")
	
	if start_animation_late:
		player.animation_player.seek(0.2)
	
	player.animation_player.animation_finished.connect(state_complete)
	player.audio_stream_player_2d.stream = lift_audio
	player.audio_stream_player_2d.play()
	pass
	
func exit() -> void:
	start_animation_late = false
	pass
	
func process(_delta: float) -> State:
	player.velocity = Vector2.ZERO
	return null

func physics(_delta: float) -> State:
	return null
	
func handled_input(_event: InputEvent) -> State:
	return null
	
func state_complete(_a: String) -> void:
	player.animation_player.animation_finished.disconnect(state_complete)
	player_state_machine.changeState(carry)
	pass
