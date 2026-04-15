@tool
class_name PatrolLocation extends Node2D

signal transform_changed

@export var wait_time: float = 0.0:
	set(v):
		wait_time = v
		_update_wait_time_label()
		
@onready var label_2: Label = $Sprite2D/Label2
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Sprite2D/Label
@onready var line_2d: Line2D = $Sprite2D/Line2D

var target_position: Vector2 = Vector2.ZERO

func _enter_tree() -> void:
	set_notify_transform(true)
 
func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		transform_changed.emit()

func _ready() -> void:
	target_position = global_position
	_update_wait_time_label()
	
	if Engine.is_editor_hint():
		return
		
	sprite_2d.queue_free()
	
func update_label(_s: String) -> void:
	label.text = _s

func update_line(next_location: Vector2) -> void:
	line_2d.points[1] = next_location - position

func _update_wait_time_label() -> void:
	if Engine.is_editor_hint() and label_2 != null:
		label_2.text = "wait: " + str(snappedf(wait_time, 0.1)) + "s"
