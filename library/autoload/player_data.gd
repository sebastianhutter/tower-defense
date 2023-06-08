extends Node
class_name PlayerData
# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents

# ========
# export vars
# ========

# @export var my_export_var = 0

# ========
# class signals
# ========

# signal my_custom_signal

# ========
# class onready vars
# ========

# @onready var my_label: Label = $%Label

# ========
# class vars
# ========

var available_ability_ids: Array[String] = [
	"shield",
	"teleport",
]

# availability ids available to player when a round starts
var selected_ability_ids: Array[String]= [
	"shield",
	"teleport",
]

# ========
# godot functions
# ========

# ========
# signal handler
# ========

# ========
# class functions
# ========

func get_available_abilities() -> Array[String]:
	"""returns the available availabilties"""
	return available_ability_ids

func get_selected_abilities() -> Array[String]:
	"""returns the selected availabilties for this round"""
	return selected_ability_ids
