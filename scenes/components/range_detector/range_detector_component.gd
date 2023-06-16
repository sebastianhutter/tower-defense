extends Area2D
class_name RangeDetectorComponent

# ========
# singleton references
# ========

# ========
# export vars
# ========

@export var detection_radius: float = 0.0 :
	get:
		return detection_radius
	set(value):
		detection_radius = value
		calculate_collision_polygon()

@export var show_indicator: bool = false :
	get:
		return show_indicator
	set(value):
		show_indicator = value
		toogle_indicator()


# ========
# class signals
# ========

# ========
# class onready vars
# ========

@onready var range: CollisionPolygon2D = $%Range
@onready var indicator: Polygon2D = $%Indicator

# ========
# class vars
# ========

var enemies_in_range: Array[Ufo] = [] 

# ========
# godot functions
# ========

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

	# calculate the initial polygon shape
	calculate_collision_polygon()

	# ensure the status of the indicator reflects the bool
	toogle_indicator()

# ========
# signal handler
# ========

func _on_area_entered(area: Area2D):


	print(area)

	if not area is Ufo:
		return

	# store reference to enemy
	enemies_in_range.append(area as Ufo)


func _on_area_exited(area: Area2D):
	# try to remove body from array, if it doesnt exist nothin happens to the array
	enemies_in_range.erase(area)

func _on_parent_mouse_entered() -> void:
	if not show_indicator:
		self.show_indicator = true

func _on_parent_mouse_exited() -> void:
	if show_indicator:
		self.show_indicator = false

# ========
# class functions
# ========

func get_first_enemy_in_line() -> Ufo:
	""" returns the first enemy in range """

	if enemies_in_range.is_empty():
		return null
	
	return enemies_in_range[0]


func calculate_collision_polygon() -> void:
	""" calculate and assign the collision polygon shape, baseline with 0 always equals the exact tile the tower is placed on """

	if not range:
		print_debug("RangeDetector: No range collison polygon found")
		return
	
	var polygon_shape: PackedVector2Array = [
		Vector2(
			Constants.TOWER_RANGE_POLYGON_BASELINE[0].x, 
			Constants.TOWER_RANGE_POLYGON_BASELINE[0].y - detection_radius * Constants.TOWER_RANGE_POLYGON_Y_RATIO
		),
		Vector2(
			Constants.TOWER_RANGE_POLYGON_BASELINE[1].x + detection_radius * Constants.TOWER_RANGE_POLYGON_X_RATIO, 
			Constants.TOWER_RANGE_POLYGON_BASELINE[1].y
		),
		Vector2(
			Constants.TOWER_RANGE_POLYGON_BASELINE[2].x, 
			Constants.TOWER_RANGE_POLYGON_BASELINE[2].y + detection_radius * Constants.TOWER_RANGE_POLYGON_Y_RATIO
		),
		Vector2(
			Constants.TOWER_RANGE_POLYGON_BASELINE[3].x - detection_radius * Constants.TOWER_RANGE_POLYGON_X_RATIO, 
			Constants.TOWER_RANGE_POLYGON_BASELINE[3].y
		),
	]


	range.polygon = polygon_shape
	
	# optionally set the indiciator polygon, if that one dont exist we dont have to abort the whole operations
	if indicator:
		indicator.polygon = polygon_shape

func toogle_indicator() -> void:
	""" toggle indicator visibility """

	if not indicator:
		return

	if show_indicator:
		indicator.show()
	else:
		indicator.hide()
