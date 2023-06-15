extends CanvasLayer
class_name TowerBuildUI

# ========
# singleton references
# ========

@onready var _custom_resource_loader = get_node("/root/CustomResourceLoaderSingleton") as CustomResourceLoader

# ========
# export vars
# ========

# @export var my_export_var = 0

# ========
# class signals
# ========

signal tower_card_clicked(tower_resource: Resource)

# ========
# class onready vars
# ========

@onready var tower_card_container: HBoxContainer = $%TowerCardContainer
@onready var tower_card_scene: PackedScene = preload(Constants.SCENE_TOWER_CARD)

# ========
# class vars
# ========

# ========
# godot functions
# ========

# ========
# signal handler
# ========

func _on_tower_card_clicked(tower_resource: Resource) -> void:
	""" called when a tower card is clicked """

	print_debug("TowerBuildUI: Tower card clicked")
	tower_card_clicked.emit(tower_resource)


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
		if tower.can_be_build == false:
			continue

		var tower_card = tower_card_scene.instantiate() as TowerCard
		tower_card_container.add_child(tower_card)
		tower_card.initialize(tower)

		# connect the tower card clicked signal to the tower build ui
		# the signal is proxied upwards until the ui manager where it is sent to
		# the game events singleton
		# the reson for this is simply to keep the dependencies between the different
		# scenes as low as possible even though it leads to some overhead
		tower_card.tower_card_clicked.connect(_on_tower_card_clicked)


func unload_tower_cards() -> void:
	""" unloads the available tower cards to allow for building"""

	for card in tower_card_container.get_children():
		card.queue_free()

func resource_gold_amount_changed(old_amount: int, new_amount: int) -> void:
	""" called by the parent hud if the resource amount has changed """
	
	for card in tower_card_container.get_children():
		var tower_card = card as TowerCard
		tower_card.check_tower_can_be_build(new_amount)