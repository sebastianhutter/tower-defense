extends Node2D

# ========
# singleton references
# ========

# ========
# export vars
# ========

# @export var my_export_var = 0

# ========
# class signals
# ========

signal tower_build_completed(resource: TowerResource, position: Vector2)

# ========
# class onready vars
# ========

@onready var construction_component: ConstructionComponent = $%ConstructionComponent

# ========
# class vars
# ========

var resource: TowerResource

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	
	construction_component.construction_completed.connect(_on_construction_completed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# ========
# signal handler
# ========

func _on_construction_completed() -> void:
	""" when the construction components timer runs out the tower is constructed and tower manager, build manager etc need to be notified """
	tower_build_completed.emit(resource, position)
	queue_free()

# ========
# class functions
# ========

func start_construction() -> void:
	construction_component.timer.wait_time = resource.get_level(0).build_time
	construction_component.timer.start()
