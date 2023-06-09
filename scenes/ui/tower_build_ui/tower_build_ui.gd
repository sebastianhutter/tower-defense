extends CanvasLayer
class_name TowerBuildUI

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

@onready var tower_card_container: HBoxContainer = $%TowerCardContainer
@onready var tower_card_scene: PackedScene = preload("res://scenes/ui/tower_card/tower_card.tscn")

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready():
	load_tower_cards()

# ========
# signal handler
# ========

# ========
# class functions
# ========

func load_tower_cards() -> void:
	""" loads the available tower cards to allow for building"""

	# only do this once!
	if tower_card_container.get_child_count() > 0:
		return

	var towers: Array[TowerResource] = _custom_resource_loader.get_tower_resources()

	if towers == null:
		return

	for tower in towers:
		if tower.is_bulldable == false:
			continue

		var tower_card = tower_card_scene.instantiate() as TowerCard
		tower_card_container.add_child(tower_card)
		tower_card.initialize(tower)
