extends Manager
class_name EnemyManager

# ========
# singleton references
# ========

@onready var _game_events = get_node("/root/GameEventsSingleton") as GameEvents
@onready var _game_data = get_node("/root/GameDataSingleton") as GameData

# ========
# export vars
# ========

@export var level_manager: LevelManager = null

# ========
# class signals
# ========

signal wave_incoming(wave_id: int, start_delay: float)
signal wave_started(wave_id: int)
signal wave_finished(wave_id: int)

# ========
# class onready vars
# ========

# TODO: remove pulsers and enemy scene
@onready var pulse: Timer = $%Pulse
@onready var enemy_scene: PackedScene = preload("res://scenes/ufo/weak_ufo/weak_ufo.tscn")


@onready var wave_incoming_timer: Timer = $%WaveIncomingTimer

# ========
# class vars
# ========

var spawn_tile_positiions: Array[Vector2]
var waves: Array[WaveResource]
var incoming_wave: int = 0

# ========
# godot functions
# ========


# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: remove pulser
	pulse.timeout.connect(_on_pulse_timeout)

	wave_incoming.connect(_on_wave_incoming)
	if wave_incoming_timer:
		wave_incoming_timer.timeout.connect(_on_wave_incoming_timer_timeout)



# ========
# signal handler
# ========


func _on_wave_incoming(wave_id: int, start_delay: float) -> void:
	""" incoming wave, set wait timer and preload enemy scenes """

	if not wave_incoming_timer:
		print_debug("no incoming timer found")
		return

	wave_incoming_timer.wait_time = start_delay
	wave_incoming_timer.start()



func _on_wave_incoming_timer_timeout() -> void:
	
	print("waaaave is coming")







func _on_pulse_timeout() -> void:

	pass

	var enemy_container: Node2D = level_manager.get_floor().enemies

	if enemy_container.get_child_count() > 3:
		return

	# # for spawn_tile_position in self.spawn_tile_positiions:
	var enemy = enemy_scene.instantiate()
	enemy.position = self.spawn_tile_positiions[0]
	enemy_container.add_child(enemy)

func spawn_enemies() -> void:
	""" spawn enemies on the floor """

	pulse.start()



# ========
# class functions
# ========

func _enter_game_loop() -> void:
	if self.spawn_tile_positiions != null:
		unload_spawn_positions()
	load_spawn_positions()	

	if self.waves != null:
		unload_waves()
	load_waves()

func _exit_game_loop() -> void:
	unload_spawn_positions()
	unload_waves()

func _game_loop() -> void:
	run_wave()


func load_spawn_positions() -> void:
	""" load the spawn positions available in the level """
	self.spawn_tile_positiions = level_manager.get_floor().spawn_tile_positions

func unload_spawn_positions() -> void:
	self.spawn_tile_positiions = []

func load_waves() -> void: 
	""" load the wave data from the selected level """
	
	self.waves = _game_data.selected_floor.waves

func unload_waves() -> void: 
	""" unload stored wave data """
	self.waves = []

func run_wave() -> void:
	""" run the current wave """

	if len(waves) <= 0:
		print_debug('no waves found')
		return
	
	wave_incoming.emit(incoming_wave, waves[0].start_delay)
	# also instruct game events that this is happening to setup ui etc
	if _game_events:
		_game_events.wave_incoming.emit(waves[0].start_delay, 0, 1, len(waves))
