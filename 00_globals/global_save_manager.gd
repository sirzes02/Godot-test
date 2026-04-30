extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var current_save: Dictionary = {
	scene_path = "",
	player = {
		level = 1,
		xp = 0,
		hp = 1,
		max_hp = 1,
		attack = 1,
		defense = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [],
	quests = [],
	abilities = ["", "", "", ""]
}

func save_game() -> void:
	update_player_data()
	update_scene_path()
	update_item_path()
	update_quest_data()

	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	file.close()
	
	game_saved.emit()
	pass
	
func get_save_file() -> FileAccess:
	return FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	
func load_game() -> void:
	var file := get_save_file()
	var json := JSON.new()
	json.parse(file.get_line())
	
	var save_dictionary: Dictionary = json.get_data() as Dictionary
	current_save = save_dictionary
	
	LevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	await LevelManager.level_load_started
	PlayerManager.set_player_position(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	PlayerManager.set_player_health(current_save.player.hp, current_save.player.max_hp)
	
	var p: Player = PlayerManager.player
	p.level = current_save.player.level
	p.xp = current_save.player.xp
	p.attack = current_save.player.attack
	p.defense = current_save.player.defense
	
	PlayerManager.INVENTORY_DATA.parse_save_data(current_save.items)
	QuestManager.current_quests = current_save.quests
	await LevelManager.level_loaded
	
	game_loaded.emit()
	pass

func update_player_data() -> void:
	var player: Player = PlayerManager.player
	current_save.player.hp = player.hp
	current_save.player.max_hp = player.max_hp
	current_save.player.pos_x = player.global_position.x
	current_save.player.pos_y = player.global_position.y
	current_save.player.level = player.level
	current_save.player.xp = player.xp
	current_save.player.attack = player.attack
	current_save.player.defense = player.defense
	current_save.abilities = player.player_abilities.abilities
	
func update_scene_path() -> void:
	var path: String = ""
	
	for child in get_tree().root.get_children():
		if child is Level:
			path = child.scene_file_path
	current_save.scene_path = path

func update_item_path() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()

func update_quest_data() -> void:
	current_save.quests = QuestManager.current_quests

func add_persistent_value(value: String) -> void:
	if !check_persistent_value(value):
		current_save.persistence.append(value)
	
	pass

func remove_persistent_value(value: String) -> void:
	var persistence = current_save.persistence as Array
	persistence.erase(value)
	pass

func check_persistent_value(value: String) -> bool:
	var persistence = current_save.persistence as Array
	return persistence.has(value)
