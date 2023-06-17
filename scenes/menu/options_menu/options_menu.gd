extends Menu
class_name GameOptionsMenu

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

signal back_button_pressed

# ========
# class onready vars
# ========

@onready var back_button: Button = $%BackButton
@onready var sfx_slider: HSlider = $%SfxSlider
@onready var music_slider: HSlider = $%MusicSlider
@onready var window_button: Button = $%WindowButton

# ========
# class vars
# ========

# ========
# godot functions
# ========

func _ready():
	if back_button:
		back_button.pressed.connect(_on_back_button_pressed)

	if window_button:
		window_button.pressed.connect(_on_window_button_pressed)

	if sfx_slider:
		sfx_slider.value_changed.connect(_on_volume_slider_changed.bind("sfx"))

	if music_slider:
		music_slider.value_changed.connect(_on_volume_slider_changed.bind("music"))

	# ensure button and slider values are correct
	update_options_display()

# ========
# signal handler
# ========

func _on_back_button_pressed() -> void:
	"""emit the play pressed signal"""
	back_button_pressed.emit()

func _on_window_button_pressed() -> void:
	""" toggle between fullscreen and window mode """

	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	update_options_display()

func _on_volume_slider_changed(value: float, bus: String) -> void:
	set_bus_volume_percent(value, bus)

# ========
# class functions
# ========

func on_show() -> void: 
	update_options_display()


func update_options_display() -> void:
	""" update text and slider values """

	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Fullscreen"

	print(sfx_slider.value)
	print( get_bus_volume_percent("sfx"))

	sfx_slider.value = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")

func get_bus_volume_percent(bus: String) -> float:
	""" return the linear representation of a audio bus db """
	var bus_id: int = AudioServer.get_bus_index(bus)
	var volume_db: float = AudioServer.get_bus_volume_db(bus_id)
	return db_to_linear(volume_db)

func set_bus_volume_percent(percent: float, bus: String) -> void:
	var bus_id: int = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(bus_id, linear_to_db(percent))
