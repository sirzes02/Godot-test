extends CanvasLayer

signal shown
signal hidden

const ERROR = preload("uid://dkp8hhu7fwovu")
const OPEN_SHOP = preload("uid://4wj7lf6jfxrk")
const PURCHASE = preload("uid://vqs1o62o41vv")
const MENU_FOCUS = preload("uid://bwxk7jcbxsmkf")
const MENU_SELECT = preload("uid://c54nib23lkpnu")
const SHOP_ITEM_BUTTON = preload("uid://dx8p01f8uelrb")

var currency: ItemData = preload("uid://8qgcg0rmriho")
var is_active: bool = false

@onready var close_button: Button = %CloseButton
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var shop_items_container: VBoxContainer = %ShopItemsContainer
@onready var gems_label: Label = %GemsLabel
@onready var animation_player: AnimationPlayer = $Control/PanelContainer/AnimationPlayer

@onready var item_image: TextureRect = %ItemImage
@onready var item_name: Label = %ItemName
@onready var item_description: Label = %ItemDescription
@onready var item_price: Label = %ItemPrice
@onready var item_held_count: Label = %ItemHeldCount


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
	populete_item_list(items)
	update_gems()
	shop_items_container.get_child(0).grab_focus()
	play_audio(OPEN_SHOP)
	shown.emit()
	pass
	
func hide_menu() -> void:
	enable_menu(false)
	clear_item_list()
	hidden.emit()
	pass

func enable_menu(_enabled: bool = true) -> void:
	get_tree().paused = _enabled
	visible = _enabled
	is_active = _enabled

func update_gems() -> void:
	gems_label.text = str(get_item_quantity(currency))
	pass

func get_item_quantity(item: ItemData) -> int:
	return PlayerManager.INVENTORY_DATA.get_item_held_quantity(item)

func clear_item_list() -> void:
	for c in shop_items_container.get_children():
		c.queue_free()
	
	pass

func populete_item_list(items: Array[ItemData]) -> void:
	for item in items:
		var shop_item: ShopItemButton = SHOP_ITEM_BUTTON.instantiate()
		shop_item.setup_item(item)
		shop_items_container.add_child(shop_item)
		shop_item.focus_entered.connect(update_item_details.bind(item))
		shop_item.pressed.connect(purchase_item.bind(item))
	pass
	
func play_audio(_audio: AudioStream) -> void:
	audio_stream_player_2d.stream = _audio
	audio_stream_player_2d.play()
	pass

func focused_item_changed(item: ItemData) -> void:
	play_audio(MENU_FOCUS)

	if item:
		update_item_details(item)

func update_item_details(item: ItemData) -> void:
	item_image.texture = item.texture
	item_name.text = item.name
	item_description.text = item.description
	item_price.text = str(item.cost)
	item_held_count.text = str(get_item_quantity(item))
	pass

func purchase_item(item: ItemData) -> void:
	var can_purchase: bool = get_item_quantity(currency) >= item.cost
	
	if can_purchase:
		play_audio(PURCHASE)
		var inv: InventoryData = PlayerManager.INVENTORY_DATA
		inv.add_item(item)
		inv.use_item(currency, item.cost)
		update_gems()
		update_item_details(item)
	else:
		play_audio(ERROR)
		animation_player.play("no_enought_gems")
		animation_player.seek(0)
	pass
