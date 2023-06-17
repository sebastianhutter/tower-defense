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
signal tower_clicked(node_id: int, tower_name: String, position: Vector2, can_be_upgraded: bool, is_max_level: bool, can_be_sold: bool, upgrade_costs: int, sell_value: int, current_level: int, speed: float, damage: float, range: float)
signal tower_context_menu_upgrade_button_clicked(node_id: int)
signal tower_context_menu_sell_button_clicked(node_id: int)
# enemy wave signals
# before a wave start warn all the systems, we pass more information then really required for most
# but this allows us setting the ui information without any additional references
signal wave_incoming(time_to_wave: float, current_wave: int, next_wave: int, wave_count: int)
signal wave_started(wave: int)
signal wave_defeated(wave: int)


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
