extends CanvasLayer
class_name HUD

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

signal tower_card_clicked(tower_resource: Resource)
signal tower_context_menu_upgrade_button_clicked(node_id: int)
signal tower_context_menu_sell_button_clicked(node_id: int)
signal send_wave()

# ========
# class onready vars
# ========

@onready var tower_build_ui: TowerBuildUI = $%TowerBuildUi
@onready var resource_ui: ResourceUi = $%ResourceUi
@onready var wave_ui: WaveUi = $%WaveUi
@onready var tower_context_menu: TowerContextMenu = $%TowerContextMenu

# ========
# class vars
# ========

var registered_uis: Array[CanvasLayer] = []

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# add the exported uis to the array so we can iterate over them for showing and hidding them
	if tower_build_ui:
		registered_uis.append(tower_build_ui)
		tower_build_ui.tower_card_clicked.connect(_on_tower_card_clicked)

	if resource_ui:
		registered_uis.append(resource_ui)

	if wave_ui:
		registered_uis.append(wave_ui)
		if wave_ui.send_wave_button:
			wave_ui.send_wave_button.pressed.connect(_on_wave_ui_send_wave_button_pressed)

	if tower_context_menu:
		registered_uis.append(tower_context_menu)
		tower_context_menu.conext_menu_closed.connect(_on_tower_context_menu_closed)
		tower_context_menu.upgrade_button_pressed.connect(_on_tower_context_menu_upgrade_button_clicked)
		tower_context_menu.sell_button_pressed.connect(_on_tower_context_menu_sell_button_clicked)

# ========
# signal handler
# ========

func _on_tower_card_clicked(tower_resource: Resource):
	""" forward tower card clicks to the ui manager """
	tower_card_clicked.emit(tower_resource)
	# when a tower card is clicked ensure any open context menus are closed
	hide_and_disable_context_menu()

func _on_resource_gold_amount_changed(old_amount: int, new_amount: int):
	for ui in registered_uis:
		if ui.has_method("resource_gold_amount_changed"):
			ui.resource_gold_amount_changed(old_amount, new_amount)

func _on_tower_clicked(node_id: int, tower_type: String, position: Vector2, can_be_upgraded: bool, is_max_level: bool, can_be_sold: bool, upgrade_costs: int, sell_value: int, current_level: int, speed: float, damage: float, range: float) -> void:
	""" received by a tower (via tower manager - game events - ui manager) """

	print_debug("HUD: tower clicked")
	show_tower_context_menu(node_id, tower_type, position, can_be_upgraded, is_max_level, can_be_sold, upgrade_costs, sell_value, current_level, speed, damage, range)

func _on_tower_context_menu_closed() -> void:
	""" hide the context menu """
	hide_and_disable_context_menu()

func _on_tower_context_menu_upgrade_button_clicked(node_id: int) -> void:
	""" pass the upgrade button signal to the ui manager """
	tower_context_menu_upgrade_button_clicked.emit(node_id)

func _on_tower_context_menu_sell_button_clicked(node_id: int) -> void:
	""" pass the sell button signal to the ui manager """
	tower_context_menu_sell_button_clicked.emit(node_id)

func _on_wave_incoming(time_to_wave: float, current_wave: int, next_wave: int, wave_count: int) -> void:
	
	if wave_ui:
		wave_ui.start_timer(time_to_wave)
		wave_ui.wave_count = wave_count

func _on_wave_started(wave: int) -> void:
	if wave_ui:
		wave_ui.current_wave = wave+1 # indexed at 0!

func _on_wave_ui_send_wave_button_pressed() -> void:
	
	#if wave_ui.wave_count > wave_ui.current_wave:
	send_wave.emit()

# ========
# class functions
# ========

func load_tower_cards() -> void:
	tower_build_ui.load_tower_cards()

func unload_tower_cards() -> void:
	tower_build_ui.unload_tower_cards()

func hide_all_uis():
	""" hide all child uis of the hud """

	for ui in registered_uis:
		ui.hide()

func show_all_uis():
	""" show all child uis of the hud """

	for ui in registered_uis:
		# do not show the tower context menu by default
		if ui is TowerContextMenu:
			continue
		
		ui.show()

func close_context_menus() -> void:
	""" close all context menus """

	hide_and_disable_context_menu()

func show_tower_context_menu(node_id: int, tower_type: String, position: Vector2, can_be_upgraded: bool, is_max_level: bool, can_be_sold: bool, upgrade_costs: int, sell_value: int, current_level: int, speed: float, damage: float, range: float):
	
	print_debug("HUD:show_tower_context_menu at " + str(position))
	tower_context_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	tower_context_menu.offset = position + Constants.TOWER_CONTEXT_MENU_OFFSET
	tower_context_menu.set_values(node_id, tower_type, can_be_upgraded, is_max_level, can_be_sold, upgrade_costs, sell_value, current_level, speed, damage, range)

	# directly connect up towers action manager 
	tower_context_menu.show()

func hide_and_disable_context_menu() -> void:
	print_debug("HUD: hide_and_disable_context_menu")
	tower_context_menu.hide()
	tower_context_menu.process_mode = Node.PROCESS_MODE_DISABLED

func reset_wave_ui() -> void:
	""" reset wave ui counters """

	if wave_ui:
		wave_ui.reset_counters()