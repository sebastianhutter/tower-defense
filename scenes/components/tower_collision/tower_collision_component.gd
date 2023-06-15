extends Area2D
class_name TowerCollisionComponent

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

signal tower_collided(tower: Tower)

# ========
# class onready vars
# ========

# ========
# class vars
# ========

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(_on_area_entered)



# ========
# signal handler
# ========

func _on_area_entered(area: Area2D):
	"""
	detect collisions with towers, the top level area2d of the tower is used for collision detection
	"""
	if not area is Tower:
		return

	print_debug("TowerCollisionComponent: tower collided " + area.name)
	tower_collided.emit(area as Tower)

# ========
# class functions
# ========

