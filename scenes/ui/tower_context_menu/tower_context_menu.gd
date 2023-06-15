extends CanvasLayer
class_name TowerContextMenu

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

signal sell_button_pressed(node_id: int)
signal upgrade_button_pressed(node_id: int)
signal conext_menu_closed()

# ========
# class onready vars
# ========

@onready var panel_container: Control = $%PanelContainer
@onready var tower_name: Label = $%TowerName
@onready var damage: Label = $%Damage
@onready var shoot_speed: Label = $%ShotSpeed
@onready var upgrade_button: Button = $%UpgradeButton
@onready var sell_button: Button = $%SellButton

# ========
# class vars
# ========

var selected_tower_node_id: int = 0
var selected_tower_upgrade_costs: int = 0
var selected_tower_is_max_level: bool = false
var selected_tower_sell_value: int = 0
# default value is set to true to ensure menu isnt closed
# before the initial mouse entered event is received when activating the menu
var mouse_is_in_context_menu: bool = true

# ========
# godot functions
# ========

func _ready() -> void:

	if upgrade_button:
		upgrade_button.pressed.connect(_on_upgrade_button_pressed)
	if sell_button:
		sell_button.pressed.connect(_on_sell_button_pressed)

	if panel_container:
		panel_container.mouse_entered.connect(_on_mouse_entered)
		panel_container.mouse_exited.connect(_on_mouse_exited)

func _unhandled_input(event: InputEvent) -> void:
	""" while the context menu is displayed ensure we can hide it when any mouse button is pressed outside of the panel """	

	if not visible:
		return

	if Input.is_action_just_pressed('Interact') or Input.is_action_just_pressed('Cancel'):
		if not mouse_is_in_context_menu:
			print_debug("TowerContextMenu: closing context menu")
			close_context_menu()

# ========
# signal handler
# ========

func _on_mouse_entered() -> void:
	mouse_is_in_context_menu = true

func _on_mouse_exited() -> void:
	mouse_is_in_context_menu = false

func _on_upgrade_button_pressed() -> void:
	print_debug("TowerContextMenu: upgrade button pressed")
	upgrade_button_pressed.emit(selected_tower_node_id)
	close_context_menu()

func _on_sell_button_pressed() -> void:
	print_debug("TowerContextMenu: sell button pressed")
	sell_button_pressed.emit(selected_tower_node_id)
	close_context_menu()

# ========
# class functions
# ========

func set_values(node_id: int, tower_type: String, can_be_upgraded: bool, is_max_level: bool, can_be_sold: bool, upgrade_costs: int, sell_value: int, current_level: int, speed: float, damage: float) -> void: 
	""" update the context menu with the values for the selected tower """
	self.selected_tower_node_id = node_id
	self.selected_tower_is_max_level = is_max_level
	self.selected_tower_upgrade_costs = upgrade_costs
	self.selected_tower_sell_value = sell_value

	set_tower_name(tower_type + ' (Lvl: ' + str(current_level+1) + ')')
	set_upgrade_costs(selected_tower_upgrade_costs, selected_tower_is_max_level)
	set_sell_value(selected_tower_sell_value)
	enable_sell_button(can_be_sold)
	enable_upgrade_button(can_be_upgraded, selected_tower_is_max_level)

func set_tower_name(tower_name: String) -> void:
	
	if not self.tower_name:
		return

	self.tower_name.text = tower_name


func set_upgrade_costs(upgrade_cost: int, is_max_level: bool) -> void:

	if not self.upgrade_button:
		return
	
	var text = 'Upgrade (G: ' + str(upgrade_cost) + ')'
	if is_max_level:
		text = 'Fully Upgraded'

	upgrade_button.text = text

func set_sell_value(sell_value: int) -> void:

	if not self.sell_button:
		return


	sell_button.text = 'Sell (G: ' + str(sell_value) + ')'

	
func enable_sell_button(sell_is_enabled: bool) -> void:
	
	if not sell_button:
		return

	sell_button.disabled = not sell_is_enabled

func enable_upgrade_button(can_upgrade: bool, is_max_level: bool) -> void:

	if not upgrade_button:
		return
	
	print_debug("TowerContextMenu: enable_upgrade_button: can_upgrade: " + str(can_upgrade) + " is_max_level: " + str(is_max_level))

	if is_max_level:
		upgrade_button.disabled = true
		return

	upgrade_button.disabled = not can_upgrade

func close_context_menu() -> void:
	""" emit the close context menu event """
	conext_menu_closed.emit()
	mouse_is_in_context_menu = true

func resource_gold_amount_changed(old_amount: int, new_amount: int) -> void:
	# """ if the new gold amount is lower then the currently set update costs disable the upgrade button """

	if not self.upgrade_button:
		return

	if selected_tower_upgrade_costs > new_amount:
		enable_upgrade_button(false, selected_tower_is_max_level)
	else:
		enable_upgrade_button(true, selected_tower_is_max_level)
	pass
