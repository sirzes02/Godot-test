extends CanvasLayer

signal shown
signal hidden

const ERROR = preload("uid://dkp8hhu7fwovu")
const OPEN_SHOP = preload("uid://4wj7lf6jfxrk")
const PURCHASE = preload("uid://vqs1o62o41vv")

var is_active: bool = false

@onready var close_button: Button = %CloseButton
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_menu()
	close_button.pressed.connect(hide_menu)
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if not is_active:
		return
		
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		hide_menu() 

func show_menu(items: Array[ItemData], dialog_triggered: bool = true) -> void:
	if dialog_triggered:
		await DialogSystem.finished
	
	enable_menu()
	play_audio(OPEN_SHOP)
	shown.emit()
	pass
	
func hide_menu() -> void:
	enable_menu(false)
	hidden.emit()
	pass

func enable_menu(_enabled: bool = true) -> void:
	get_tree().paused = _enabled
	visible = _enabled
	is_active = _enabled
	
func play_audio(_audio: AudioStream) -> void:
	audio_stream_player_2d.stream = _audio
	audio_stream_player_2d.play()
	pass
