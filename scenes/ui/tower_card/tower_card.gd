extends PanelContainer
class_name TowerCard 

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _player_data = get_node("/root/PlayerDataSingleton") as PlayerData

# ========
# export vars
# ========

# @export var my_export_var = 0

# ========
# class signals
# ========

signal tower_card_clicked(tower_resource: Resource)

# ========
# class onready vars
# ========

@onready var tower_card_texture: TextureRect = $%TowerCardTexture
@onready var tower_name_label: Label = $%TowerNameLabel
@onready var tower_cost_label: Label = $%TowerCostLabel
@onready var background: Panel = $%Background

# ========
# class vars
# ========

var resource: TowerResource
var can_be_build: bool = false

# var ability_card_flash_material: Resource = preload("res://resources/shader/card_flash/card_flash_material.tres")
# var ability_card_flash_tween: Tween

# ========
# godot functions
# ========

func _ready():
	# connect game events to control if the tower can be build or not
	_game_events.resource_gold_amount_changed.connect(_on_resource_gold_amount_changed)

	# connect signal for clickcing of the card
	# forward it to the gamevents so towermanager and resourcemanager can be informed
	tower_card_clicked.connect(_game_events._on_tower_card_clicked)

	mouse_entered.connect(_gui_mouse_entered)
	mouse_exited.connect(_gui_mouse_exited)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed  and can_be_build:
		tower_card_clicked.emit(resource)

# ========
# signal handler
# ========

func _gui_mouse_entered() -> void:
	"""highlight the card when the mouse enters"""

	if not background:
		print_debug("TowerCard: background is null")
		return
	
	if can_be_build:
		background.modulate.a = 255

func _gui_mouse_exited() -> void:
	"""unhighlight the card when the mouse exits"""

	if not background:
		print_debug("TowerCard: background is null")
		return

	background.modulate.a = 0

func _on_resource_gold_amount_changed(old_amount: int, new_amount: int) -> void:
	if new_amount >= resource.get_level(0).build_costs:
		enable_build()
	else:
		disable_build()

# ========
# class functions
# ========

func initialize(tower_resource: Resource) -> void:
	"""
	initialize the card with the tower resource data
	"""

	resource = tower_resource
	set_icon_texture(resource.build_icon)
	set_tower_name()
	set_tower_cost()

func set_icon_texture(icon: Texture) -> void:

	if not tower_card_texture:
		print_debug("TowerCard: tower_card_texture is null")
		return
	
	tower_card_texture.texture = icon

func set_tower_name() -> void:
	
	if not tower_name_label:
		print_debug("TowerCard: tower_name_label is null")
		return

	tower_name_label.text = resource.name

func set_tower_cost() -> void:
	
	if not tower_cost_label:
		print_debug("TowerCard: tower_cost_label is null")
		return

	tower_cost_label.text = 'Gold: ' + str(resource.get_level(0).build_costs)

func enable_build() -> void:
	"""enable the card to be build"""

	can_be_build = true
	if tower_cost_label:
		tower_cost_label.modulate = Color(255,255,255,255)
	
func disable_build() -> void:

	# todo: use theme overrites or something else
	can_be_build = false
	if tower_cost_label:
		tower_cost_label.modulate = Color(0,100,100,255)

