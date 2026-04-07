class_name EnemyCounter extends Node

signal enemies_defeated

func _ready() -> void:
	child_exiting_tree.connect(_on_enemy_destroyed)
	pass
	
func _on_enemy_destroyed(enemy: Node2D) -> void:
	if enemy is Enemy and enemy_count() <= 1:
		enemies_defeated.emit()
 
	pass

func enemy_count() -> int:
	var _count: int = 0
	
	for child in get_children():
		if child is Enemy:
			_count += 1
	
	return _count
