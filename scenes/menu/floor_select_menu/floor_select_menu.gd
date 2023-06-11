extends Menu
class_name GameFloorSelectMenu

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

signal start_game_button_pressed(floor_resource: FloorResource)
signal back_button_pressed

# ========
# class onready vars
# ========

@onready var back_button: Button = $%BackButton
@onready var start_game_button: Button = $%StartGameButton

@onready var floor_select_container: HBoxContainer = $%FloorSelectContainer
@onready var floor_select_card_scene: PackedScene = preload(Constants.SCENE_FLOOR_SELECT_CARD)

# ========
# class vars
# ========

var floor_cards: Array[FloorSelectCard] = []
var selected_floor: FloorResource = null
# ========
# godot functions
# ========

func _ready():
	back_button.pressed.connect(_on_back_button_pressed)
	start_game_button.pressed.connect(_on_start_game_button_pressed)

	# disable start game button until floor is selected!
	start_game_button.disabled = true

	load_floor_cards()

# ========
# signal handler
# ========

func _on_back_button_pressed() -> void:
	"""emit the play pressed signal"""
	back_button_pressed.emit()

func _on_start_game_button_pressed() -> void:
	"""emit the play pressed signal"""

	start_game_button_pressed.emit(selected_floor)

func _on_floor_selected(floor_resource: FloorResource) -> void:
	""" called when a floor is selected """

	# enable start game button
	start_game_button.disabled = false

	# set selected floor
	selected_floor = floor_resource

	# deselect all other floor cards
	for card in floor_cards:
		if card.floor_resource.name != floor_resource.name:
			card.deselect()


# ========
# class functions
# ========

func load_floor_cards() -> void:
	""" loads all available floor cards """

	var floors: Array[FloorResource] = _custom_resource_loader.get_floor_resources()
	if floors == null:
		print_debug("No floors found!")
		return

	for floor in floors:
		if not floor.enabled:
			continue
		
		var floor_card = floor_select_card_scene.instantiate() as FloorSelectCard
		floor_select_container.add_child(floor_card)
		floor_card.initialize(floor)
		floor_card.floor_selected.connect(_on_floor_selected)
		floor_cards.append(floor_card)
