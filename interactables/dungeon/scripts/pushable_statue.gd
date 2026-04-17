class_name PushableStatus extends RigidBody2D

@export var push_speed: float = 30.0
@export var persitent: bool = false
@export var persitent_location: Vector2 = Vector2.ZERO
@export var target_location_size: Vector2 = Vector2(4, 4)

var push_direction: Vector2 = Vector2.ZERO:
	set = _set_push
var on_target: bool = false
	
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var persistent_data_handler: PersistentDataHandler = $OnTarget

func _ready() -> void:
	if persistent_data_handler.value:
		position = persitent_location
	pass

func _physics_process(_delta: float) -> void:
	linear_velocity = push_direction * push_speed
	
	if persitent:
		var x_is_on: bool = abs(position.x - persitent_location.x) < 15 + target_location_size.x
		var y_is_on: bool = abs(position.y - persitent_location.y) < 6 + target_location_size.y
		
		if x_is_on and y_is_on and not on_target:
			on_target = true
			persistent_data_handler.set_value()
		elif (not x_is_on or not y_is_on) and on_target:
			on_target = false
			persistent_data_handler.remove_value()
	pass
	
func _set_push(value: Vector2):
	push_direction = value
	
	if push_direction == Vector2.ZERO:
		audio_stream_player_2d.stop()
	else:
		audio_stream_player_2d.play()
	pass
