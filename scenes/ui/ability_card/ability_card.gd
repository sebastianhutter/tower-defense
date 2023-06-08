extends PanelContainer
class_name AbilityCard 

# ========
# singleton references
# ========

@onready var _helper = get_node("/root/HelperSingleton") as Helper
@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _player_data = get_node("/root/PlayerDataSingleton") as PlayerData

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

@onready var ability_icon_texture: TextureRect = $%AbilityIconTexture

# ========
# class vars
# ========

var ability_id: String

var ability_card_flash_material: Resource = preload("res://resources/shader/card_flash/card_flash_material.tres")
var ability_card_flash_tween: Tween

# ========
# godot functions
# ========

func _ready():

	# connect game event signals for ability states
	_game_events.ability_activated.connect(_on_ability_activated)
	_game_events.ability_recovery_started.connect(_on_ability_recovery_started)
	_game_events.ability_recovery_complete.connect(_on_ability_recovrty_complete)

# ========
# signal handler
# ========

func _on_ability_activated(ability_id: String) -> void:
	"""flash the card if the ability was activated"""

	if ability_id != self.ability_id:
		return

	flash()

func _on_ability_recovery_started(ability_id: String, recovery_time: float) -> void:
	"""flash the card if the ability was activated"""

	if ability_id != self.ability_id:
		return

	pass

func _on_ability_recovrty_complete(ability_id: String) -> void:
	"""flash the card if the ability was activated"""

	if ability_id != self.ability_id:
		return

	pass

# ========
# class functions
# ========

func set_icon_texture(icon: Texture) -> void:
	ability_icon_texture.texture = icon

func set_card_material(material_resource: Resource) -> void:
	"""
	set the shader material of the card
	"""

	material = material_resource

func clear_card_material() -> void:
	"""
	removes the material from the card
	"""

	material = null


func flash() -> void:
	"""flash the card"""

	if ability_card_flash_tween != null and ability_card_flash_tween.is_valid():
		ability_card_flash_tween.kill()

	set_card_material(ability_card_flash_material)
	(material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	ability_card_flash_tween = create_tween()	
	ability_card_flash_tween.tween_property(material, "shader_parameter/lerp_percent", 0.0, 0.1) 
	ability_card_flash_tween.tween_callback(clear_card_material)
	
