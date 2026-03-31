class_name State_Attack extends State

var attacking: bool = false

@export var attack_sound: AudioStream
@export_range(1, 20, 0.5) var decelerate_speed: float = 5.0

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var animation_attack: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var idle: State_Idle = $"../Idle"
@onready var walk: State_Walk = $"../Walk"
@onready var hurt_box: HurtBox = $"../../Interactions/HurtBox"

func enter() -> void:
	player.updateAnimation("attack")
	animation_attack.play("attack_" + player.animDirection())
	animation_player.animation_finished.connect(end_attack )
	
	audio_stream_player_2d.stream = attack_sound
	audio_stream_player_2d.pitch_scale = randf_range(0.9, 1.1)
	audio_stream_player_2d.play()
	
	attacking = true
	await get_tree().create_timer(0.075).timeout
	hurt_box.monitoring = true
	pass
	
func exit() -> void:
	animation_player.animation_finished.disconnect(end_attack )
	attacking = false
	hurt_box.monitoring = false
	pass
	
func process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if !attacking:
		return idle if player.direction == Vector2.ZERO else walk
	
	return null

func physics(_delta: float) -> State:
	return null
	
func handled_input(_event: InputEvent) -> State:
	return null

func end_attack(_newAnimName: String) -> void:
	attacking = false
