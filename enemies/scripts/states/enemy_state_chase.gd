class_name EnemyStateChase extends EnemyState

const PATHFINDER: PackedScene = preload("res://enemies/pathfinder.tscn")

@export var anim_name: String = "chase"
@export var chase_speed: float = 40.0
@export var turn_rate: float = 0.25

@export_category("AI")
@export var vision_area: VisionArea
@export var attack_area: HurtBox
@export var state_aggro_duration: float = 0.5
@export var next_state: EnemyState

var pathfinder: Pathfinder
var _timer: float = 0.0
var _direction: Vector2
var _can_see_player: bool = false

func init() -> void:
	if vision_area:
		vision_area.player_entered.connect(_on_player_enter)
		vision_area.player_exited.connect(_on_player_exit)
	
	pass

func enter() -> void:
	pathfinder = PATHFINDER.instantiate()
	enemy.add_child(pathfinder)
	_timer = state_aggro_duration
	enemy.updateAnimation(anim_name)
	
	if attack_area:
		attack_area.monitoring = true
	pass
	
func exit() -> void:
	pathfinder.queue_free()

	if attack_area:
		attack_area.monitoring = false

	_can_see_player = false
	pass
	
func process(_delta: float) -> EnemyState:
	if PlayerManager.player.hp <= 0:
		return next_state
	
	_direction = lerp(_direction, pathfinder.best_path, turn_rate)
	enemy.velocity = _direction * chase_speed
	
	if enemy.setDirection(_direction):
		enemy.updateAnimation(anim_name)
	
	if !_can_see_player:
		_timer -= _delta
		
		if _timer < 0:
			return next_state
	else:
		_timer -= state_aggro_duration
	
	return null

func physics(_delta: float) -> State:
	return null
	
func _on_player_enter() -> State:
	_can_see_player = true
	
	if enemy_state_machine.current_state is EnemyStateStun or enemy_state_machine.current_state is EnemyStateDestroy:
		return
	
	enemy_state_machine.changeState(self)
	return null
	
func _on_player_exit() -> State:
	_can_see_player = false
	return null
