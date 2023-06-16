extends Node2D

# ========
# singleton references
# ========

# ========
# export vars
# ========

@export var length: float = 0

# ========
# class signals
# ========

# ========
# class onready vars
# ========

@onready var collision_polygon: CollisionPolygon2D = $%CollisionPolygon2D


# ========
# class vars
# ========

var POLYGON_INITIAL_SHAPE: PackedVector2Array = [
	# first point, on x axis, pointing "up"
	Vector2(0, -117),
	# second point, on y axis , pointing "right"
	Vector2(127, -43),
	# third point, on x axis, pointing "down"
	Vector2(0, 30),
	# fourth point, on y axis, pointing "left"
	Vector2(-127, -43),
]

# the points on the x axis need to be increased by ca 146 pixels for one tilemap
var Y_RATIO: int = 146
# the points on the y axis need to be increased by ca 251 pixels for one tilemap
var X_RATIO: int = 251



# ========
# godot functions
# ========

func _process(_delta) -> void:
	
	var shape: PackedVector2Array = return_polygon_shape(POLYGON_INITIAL_SHAPE, length)
	collision_polygon.polygon = shape



# ========
# signal handler
# ========

# ========
# class functions
# ========

func return_polygon_shape(initial_polygon_shape: PackedVector2Array, length: float) -> PackedVector2Array:	
	
	var new_packed_array: PackedVector2Array = [
		Vector2(initial_polygon_shape[0].x, initial_polygon_shape[0].y - length * Y_RATIO),
		Vector2(initial_polygon_shape[1].x + length * X_RATIO, initial_polygon_shape[1].y),
		Vector2(initial_polygon_shape[2].x, initial_polygon_shape[2].y + length * Y_RATIO),
		Vector2(initial_polygon_shape[3].x - length * X_RATIO, initial_polygon_shape[3].y),
	]

	return new_packed_array