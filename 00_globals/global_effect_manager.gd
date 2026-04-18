extends Node

const DAMAGE_TEXT = preload("uid://bbs2g7wkbxnf7")

func damage_text(_damage: int, _pos: Vector2) -> void:
	var _t: DamageText = DAMAGE_TEXT.instantiate()
	add_child(_t)
	_t._start(str(_damage), _pos)
	pass
