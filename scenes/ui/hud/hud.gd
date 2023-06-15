extends CanvasLayer
class_name HUD

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

signal tower_card_clicked(tower_resource: Resource)

# ========
# class onready vars
# ========

@onready var tower_build_ui: TowerBuildUI = $%TowerBuildUi
@onready var resource_ui: ResourceUi = $%ResourceUi
@onready var wave_ui: WaveUi = $%WaveUi

# ========
# class vars
# ========

var registered_uis: Array[CanvasLayer] = []

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# add the exported uis to the array so we can iterate over them for showing and hidding them
	if tower_build_ui:
		registered_uis.append(tower_build_ui)
		tower_build_ui.tower_card_clicked.connect(_on_tower_card_clicked)

	if resource_ui:
		registered_uis.append(resource_ui)

	if wave_ui:
		registered_uis.append(wave_ui)

# ========
# signal handler
# ========

func _on_tower_card_clicked(tower_resource: Resource):
	""" forward tower card clicks to the ui manager """
	tower_card_clicked.emit(tower_resource)

func _on_resource_gold_amount_changed(old_amount: int, new_amount: int):
	for ui in registered_uis:
		if ui.has_method("resource_gold_amount_changed"):
			ui.resource_gold_amount_changed(old_amount, new_amount)

# ========
# class functions
# ========

func load_tower_cards() -> void:
	tower_build_ui.load_tower_cards()

func unload_tower_cards() -> void:
	tower_build_ui.unload_tower_cards()

func hide_all_uis():
	""" hide all child uis of the hud """

	for ui in registered_uis:
		ui.hide()

func show_all_uis():
	""" show all child uis of the hud """

	for ui in registered_uis:
		ui.show()