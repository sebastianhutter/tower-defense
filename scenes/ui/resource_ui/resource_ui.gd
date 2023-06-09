extends CanvasLayer
class_name ResourceUi

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

@onready var gold_label: Label = $%GoidLabel

# ========
# class vars
# ========

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	_game_events.resource_gold_amount_changed.connect(resource_gold_amount_changed)	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# ========
# signal handler
# ========

func resource_gold_amount_changed(old_amount: int, new_amount: int):
	""" set the label to the new amount """

	# TODO: add some lerping to count down or up the amount... just to make it look more fancy
	gold_label.text = 'Gold: '+ str(new_amount)

# ========
# class functions
# ========

