class_name State_Carry extends State

@export var move_speed: float = 100.0
@export var throw_audio: AudioStream

var walking: bool = false
var throwable: Throwable

@onready var idle: State_Idle = $"../Idle"
@onready var stun: State_Stun = $"../Stun"

func init() -> void:
	pass

func enter() -> void:
	player.updateAnimation("carry")
	walking = false
	pass
	
func exit() -> void:
	if throwable:
		if player.direction == Vector2.ZERO:
			throwable.throw_direction = player.cardinal_direction
		else:
			throwable.throw_direction = player.direction
		
		if player_state_machine.next_state == stun:
			throwable.throw_direction = throwable.throw_direction.rotated(PI)
			throwable.drop()
		else:
			player.audio_stream_player_2d.stream = throw_audio
			player.audio_stream_player_2d.play()
			throwable.throw()
		
		pass
	
	pass
	
func process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		walking = false
		player.updateAnimation("carry")
	elif player.setDirection() or not walking:
		player.updateAnimation("carry_walk")
		walking = true
	
	player.velocity = player.direction * move_speed
	return null

func physics(_delta: float) -> State:
	return null
	
func handled_input(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack") or _event.is_action_pressed("interact"):
		return idle
	
	return null
