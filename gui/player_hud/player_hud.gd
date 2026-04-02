extends CanvasLayer

var hearts: Array[HeartGUI] = []

@onready var h_flow_container: HFlowContainer = $Control/HFlowContainer

func _ready() -> void:
	for child in h_flow_container.get_children():
		if child is HeartGUI:
			hearts.append(child)
			child.visible = false
		
	pass 

func update_hp(_hp: int, _max_hp: int) -> void:
	update_max_hp(_max_hp)
	
	for i in _max_hp:
		update_hearth(i, _hp)
		pass
		
	pass

func update_hearth(_index: int, _hp: int) -> void:
	var _value: int = clampi(_hp - _index * 2, 0, 2)
	hearts[_index].value = _value
	pass

func update_max_hp(_max_hp: int) -> void:
	var _heart_count: int = roundi(_max_hp * 0.5)
	
	for i in hearts.size():
		hearts[i].visible = i < _heart_count
	
	pass
