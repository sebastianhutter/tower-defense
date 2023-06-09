extends Node
class_name GameEvents

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _player_data = get_node("/root/PlayerDataSingleton") as PlayerData

# ========
# export vars
# ========

# @export var my_export_var = 0

# ========
# class signals
# ========

signal game_state_changed(game_state: Types.GameState, payload: Dictionary)
signal resource_gold_amount_changed(old_amount: int, new_amount: int)
signal tower_card_clicked(resource: TowerResource)
# ========
# class onready vars
# ========

# @onready var my_label: Label = $%Label

# ========
# class vars
# ========

# ========
# godot functions
# ========

# ========
# signal handler
# ========


func _on_game_state_changed(game_state: Types.GameState, payload: Dictionary = {}) -> void:
	"""Called when the game state changes, proxies signal from gamestatemanager to other nodes"""

	print_debug("GameEvents", "_on_game_state_changed", "Game state changed: " + str(game_state))
	game_state_changed.emit(game_state)


func _on_resource_gold_amount_changed(old_amount: int, new_amount: int) -> void:
	"""Called when a resource amount changes"""

	print_debug("GameEvents", "_on_resource_gold_amount_changed", "Resource amount changed: " + str(old_amount) + " -> " + str(new_amount))
	resource_gold_amount_changed.emit(old_amount, new_amount)

func _on_tower_card_clicked(resource: TowerResource) -> void:
	"""Called when a tower card is clicked"""

	print_debug("GameEvents", "_on_tower_card_clicked", "Tower card clicked: " + str(resource))
	tower_card_clicked.emit(resource)

# ========
# class functions
# ========
