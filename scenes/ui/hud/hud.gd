extends CanvasLayer
class_name HUD

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

	if resource_ui:
		registered_uis.append(resource_ui)

	if wave_ui:
		registered_uis.append(wave_ui)

# ========
# signal handler
# ========

func _on_custom_signal_event():
	pass

# ========
# class functions
# ========

func hide_all_uis():
	""" hide all child uis of the hud """

	for ui in registered_uis:
		ui.hide()

func show_all_uis():
	""" show all child uis of the hud """

	for ui in registered_uis:
		ui.show()