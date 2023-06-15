extends PanelContainer
class_name FloorSelectCard

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

signal floor_selected(floor_resource: FloorResource)

# ========
# class onready vars
# ========

@onready var floor_name_label: Label = $%FloorNameLabel
@onready var floor_descrtiption_label: Label = $%FloorDescriptionLabel
@onready var floor_preview_texture: TextureRect = $%FloorPreviewTexture
# TODO: fix up some proper animation / colorng, for now we just show a colorrect
# if the card is selected
@onready var floor_card_color_rect: ColorRect = $%FloorCardColorRect

# ========
# class vars
# ========

var floor_resource: FloorResource = null

# ========
# godot functions
# ========

func _ready() -> void:
	floor_card_color_rect.hide()


func _gui_input(event):
	if Input.is_action_pressed("Interact"):
		select()

# ========
# signal handler
# ========

# ========
# class functions
# ========

func initialize(floor_resource: FloorResource):
	self.floor_resource = floor_resource


	set_icon_texture(floor_resource.preview)

	floor_name_label.text = floor_resource.name
	floor_descrtiption_label.text = floor_resource.description

func set_icon_texture(texture: Texture):

	if not floor_preview_texture:
		print_debug("FloorSelectCard: floor_preview_texture is null")
		return

	floor_preview_texture.texture = texture

func select():
	"""
	select the given floor
	"""

	print_debug("select floor card " + floor_resource.name)
	floor_selected.emit(floor_resource)
	floor_card_color_rect.show()

	

func deselect():
	"""
	deselect the given floor
	"""
	
	floor_card_color_rect.hide()
