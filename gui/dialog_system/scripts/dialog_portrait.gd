@tool
class_name DialogPortrait extends Sprite2D

var blink: bool = false:
	set = _set_blink
var open_mounth: bool = false:
	set = _set_open_mounth
var mounth_open_frames: int = 0
var audio_pitch_base: float = 1.0

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	DialogSystem.letter_added.connect(check_mouth_open)
	blinker()

func check_mouth_open(l: String) -> void:
	if 'aeiou1234567890'.contains(l):
		open_mounth = true
		mounth_open_frames += 4
		audio_stream_player.pitch_scale = randf_range(audio_pitch_base - 0.04, audio_pitch_base + 0.04)
		audio_stream_player.play()
	elif '.,!?'.contains(l):
		mounth_open_frames = 0
	
	if mounth_open_frames > 0:
		mounth_open_frames -= 1
		
	if mounth_open_frames == 0:
		open_mounth = false 
	
	pass
	
func update_portrait() -> void:
	if open_mounth:
		frame = 2
	else:
		frame = 0
		
	if blink:
		frame += 1

func blinker() -> void:
	if !blink:
		await get_tree().create_timer(randf_range(0.1, 3)).timeout
	else:
		await get_tree().create_timer(0.15).timeout
		
	blink = not blink
	blinker()
	
func _set_blink(_value: bool) -> void:
	if blink != _value:
		blink = _value
	
	pass

func _set_open_mounth(_value: bool) -> void:
	if open_mounth != _value:
		open_mounth = _value
		update_portrait()

	pass
