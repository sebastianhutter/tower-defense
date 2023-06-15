extends Node
class_name GameEvents

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

# emitted when the game state changes
signal game_state_changed(game_state: Types.GameState, payload: Dictionary)
# emitted when the gold amount changes
signal resource_gold_amount_changed(old_amount: int, new_amount: int)
# tower construction related events
signal tower_card_clicked(resource: TowerResource)
signal tower_build_started(resource: TowerResource, position: Vector2)
# tower resoruce related events
signal tower_build_completed(resource: TowerResource, position: Vector2)
signal tower_upgrade_started(build_costs: int)
signal tower_sold(sell_value: int, position: Vector2)
signal tower_destroyed(id: Types.Tower, position: Vector2)
# if a tower is clicked the event is sent by the tower manager and handled in the ui 
# to display the towers context menu
signal tower_clicked(node_id: int, tower_name: String, position: Vector2, can_be_upgraded: bool, can_be_sold: bool, upgrade_costs: int, sell_value: int)
signal tower_context_menu_upgrade_button_clicked(node_id: int)
signal tower_context_menu_sell_button_clicked(node_id: int)

# ========
# class onready vars
# ========

# ========
# class vars
# ========

# ========
# godot functions
# ========

# ========
# signal handler
# ========

# ========
# class functions
# ========
