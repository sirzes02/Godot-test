@tool
@icon("res://npc/icons/npc.svg")
class_name NPC extends CharacterBody2D

signal do_behavior_enabled

var state: String = "idle"
var direction: Vector2 = Vector2.ZERO
var direction_name: String = "down"
var do_behavior: bool = true

@export var npc_resource: NPCResource:
	set = _set_npc_resource

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	setup_npc()
	
	if Engine.is_editor_hint():
		return
	
	do_behavior_enabled.emit()
	pass
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	
func update_animation() -> void:
	animation_player.play(state + "_" + direction_name)

func update_direction(target_position: Vector2) -> void:
	direction = global_position.direction_to(target_position)
	update_direction_name()
	
	if direction_name == "side" and direction.x < 0:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
	
func update_direction_name()-> void:
	var threshold: float = 0.5
	
	if direction.y < -threshold:
		direction_name = "up"
	elif direction.y > threshold:
		direction_name = "down"
	elif direction.x > threshold or direction.x < -threshold:
		direction_name = "side"

func setup_npc() -> void:
	if npc_resource:
		if sprite_2d:
			sprite_2d.texture = npc_resource.sprite
	pass
	
func _set_npc_resource(_npc: NPCResource) -> void:
	npc_resource = _npc
	setup_npc()
