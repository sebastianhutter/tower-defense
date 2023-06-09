extends Node2D
class_name TowerBuildPreview

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

@onready var preview: Sprite2D = $%Preview

# ========
# class vars
# ========

var is_buildable: bool = false

# ========
# godot functions
# ========

func _process(_delta) -> void:
	set_highlight_color(is_buildable)

# ========
# signal handler
# ========

# ========
# class functions
# ========

func set_highlight_color(is_buildable: bool) -> void:
	""" set green highlight color for shader """

	if is_buildable:
		preview.material.set('shader_parameter/highlight_color', Color8(0,255,0,100))
	else:
		preview.material.set('shader_parameter/highlight_color', Color8(255,0,0,100))


func set_preview_image(texture: Texture) -> void:
	
	if not preview:
		print_debug("preview not found")
		return
	
	preview.texture = texture