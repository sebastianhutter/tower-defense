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
