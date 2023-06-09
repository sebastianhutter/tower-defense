extends CanvasLayer
class_name TowerContextMenu
# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _player_data = get_node("/root/PlayerDataSingleton") as PlayerData
@onready var _custom_resource_loader = get_node("/root/CustomResourceLoaderSingleton") as CustomResourceLoader

# ========
# export vars
# ========

# ========
# class signals
# ========

signal sell_button_pressed()
signal upgrade_button_pressed()

# ========
# class onready vars
# ========

@onready var tower_name: Label = $%TowerName
@onready var damage: Label = $%Damage
@onready var shoot_speed: Label = $%ShotSpeed
@onready var upgrade_button: Button = $%UpgradeButton
@onready var sell_button: Button = $%SellButton

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready() -> void:

	if upgrade_button:
		upgrade_button.pressed.connect(_on_upgrade_button_pressed)
	if sell_button:
		sell_button.pressed.connect(_on_sell_button_pressed)

# ========
# signal handler
# ========

func _on_upgrade_button_pressed() -> void:
	upgrade_button_pressed.emit()

func _on_sell_button_pressed() -> void:
	sell_button_pressed.emit()

# ========
# class functions
# ========

func set_tower_name(tower_name: String) -> void:
	
	if not self.tower_name:
		return

	self.tower_name.text = tower_name

func set_damage(tower_damage: int) -> void:

	if not self.damage:
		return

	damage.text = 'Damage: ' + str(tower_damage)

func set_speed(tower_speed: float) -> void:

	if not self.shoot_speed:
		return

	shoot_speed.text = 'Shoot Speed: ' + str(tower_speed)

func set_upgrade_cost(upgrade_cost: int) -> void:

	if not self.upgrade_button:
		return

	upgrade_button.text = 'Upgrade (G: ' + str(upgrade_cost) + ')'

func set_sell_value(sell_value: int) -> void:

	if not self.sell_button:
		return

	sell_button.text = 'Sell (G: ' + str(sell_value) + ')'


func activate_upgrade_button(upgrade_is_enabled: bool) -> void:
	
	if not self.upgrade_button:
		return

	upgrade_button.disabled = not upgrade_is_enabled
	
func enable_sell_button(sell_is_enabled: bool) -> void:
	
	if not sell_button:
		return

	sell_button.disabled = not sell_is_enabled
	if sell_is_enabled:
		sell_button.show()
	else:
		sell_button.hide()
