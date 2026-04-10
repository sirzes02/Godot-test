extends Node

const PLAYER = preload("uid://b4sse476kdci4")
const INVENTORY_DATA: InventoryData = preload("res://gui/pause_menu/inventory/player_inventory.tres")

signal camera_shook(trauma: float)
signal interact_pressed

var interact_handled: bool = true
var player: Player
var player_spawned: bool = false

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.5).timeout
	player_spawned = true

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)
	pass

func set_player_health(hp: int, max_hp: int) -> void:
	player.max_hp = max_hp
	player.hp = hp
	player.update_hp(0)

func set_player_position(_new_pos: Vector2) -> void:
	player.global_position = _new_pos
	pass

func set_as_parent(_p: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	
	_p.add_child(player)
	pass
	
func unparent_parent(_p: Node2D) -> void:
	_p.remove_child(player)
	pass
	
func play_audio(audio: AudioStream):
	player.audio_stream_player_2d.stream = audio
	player.audio_stream_player_2d.play()

func interact() -> void:
	interact_handled = false
	interact_pressed.emit()

func shake_camera(trauma: float = 1) -> void:
	camera_shook.emit(trauma)
