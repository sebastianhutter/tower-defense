extends CanvasLayer
class_name AbilityUi

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

# @export var my_export_var = 0

# ========
# class signals
# ========

# signal my_custom_signal

# ========
# class onready vars
# ========

@onready var ability_card_container: HBoxContainer = $%AbilityCardContainer
@onready var ability_card_scene: PackedScene = preload("res://scenes/ui/ability_card/ability_card.tscn")

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

func load_ability_cards() -> void:
	"""loads the player abilities into the ui"""

	# only do this once!
	if ability_card_container.get_child_count() > 0:
		return
	
	var abilities = _player_data.get_selected_abilities()
	for aid in abilities:
		var ability_resource = _custom_resource_loader.get_ability_resource(aid)
		if ability_resource == null:
			continue
	
		var ability_card = ability_card_scene.instantiate() as AbilityCard	
		ability_card_container.add_child(ability_card)
		ability_card.ability_id = aid
		ability_card.set_icon_texture(ability_resource.icon)
