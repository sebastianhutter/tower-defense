extends Camera2D
class_name GameCamera

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

@export var min_zoom: float = 0.3
@export var max_zoom: float = 1.0
@export var zoom_interval: float = 0.1
@export var zoom_speed: float = 10.0
@export var pan_speed: float = 10.0

# ========
# class signals
# ========


# ========
# class onready vars
# ========

# ========
# class vars
# ========

var is_middle_mouse_button_pressed: bool = false
var target_zoom_level: float
var hq_tween: Tween

# ========
# godot functions
# ========

func _ready() -> void:
	make_current()
	target_zoom_level = zoom.x

func _physics_process(delta):
	zoom = lerp(zoom, target_zoom_level * Vector2.ONE, zoom_speed * delta)

func _input(event: InputEvent) -> void:
	pan_camera_with_mouse(event)
	pan_camera_with_keyboard(event)
	zoom_camera(event)
	move_camera_to_hq(event)
	
# ========
# signal handler
# ========

# ========
# class functions
# ========

func pan_camera_with_mouse(event: InputEvent) -> void:
	"""
	handles panning of camera
	"""

	if Input.is_action_just_pressed("PanCamera"):
		is_middle_mouse_button_pressed = true
	if Input.is_action_just_released("PanCamera"):
		is_middle_mouse_button_pressed = false
	
	if event is InputEventMouseMotion and is_middle_mouse_button_pressed:
		position -= (event as InputEventMouseMotion).relative * pan_speed

func pan_camera_with_keyboard(event: InputEvent) -> void:
	"""handles panning of camera with keyboard"""
	
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += input_vector * pan_speed


func zoom_camera(event: InputEvent) -> void:
	"""
	handles zooming of camera
	"""

	if Input.is_action_pressed("ZoomCameraIn"):
		target_zoom_level = max(target_zoom_level - zoom_interval, min_zoom)
	if Input.is_action_pressed("ZoomCameraOut"):
		target_zoom_level = max(target_zoom_level + zoom_interval, max_zoom)

func move_camera_to_hq(event: InputEvent):
	"""moves the camera to the hq"""
	
	if Input.is_action_pressed("ResetCameraPosition"):
		var hq: Node2D = get_tree().get_first_node_in_group("hq")
		if not hq:
			return

		if hq_tween:
			hq_tween.kill()

		hq_tween = create_tween()
		hq_tween.tween_property(self, "position", hq.position, 1.0)
	
