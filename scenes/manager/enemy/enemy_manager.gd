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
@export var spawn_delay: float = 1.0 # delay between enemy spawns

# ========
# class signals
# ========

signal wave_incoming(wave_id: int)
signal wave_started(wave_id: int)

# ========
# class onready vars
# ========

@onready var wave_incoming_timer: Timer = $%WaveIncomingTimer
@onready var spawn_timer: Timer = $%SpawnTimer

# ========
# class vars
# ========

var initial_wave_started: bool = false

var spawn_tile_positiions: Array[Vector2]
var waves: Array[WaveResource]
var current_wave: int = 0
var incoming_wave: int = 0

var enemy_placement_node: Node2D
var last_used_spawn_tile_position: int = -1
var preloaded_enemies_per_wave: Array
var enemies_per_wave_count: Array

# ========
# godot functions
# ========

# Called when the node enters the scene tree for the first time.
func _ready():

	wave_incoming.connect(_on_wave_incoming)
	wave_started.connect(_on_wave_started)
	if wave_incoming_timer:
		wave_incoming_timer.timeout.connect(_on_wave_incoming_timer_timeout)

	if spawn_timer:
		spawn_timer.wait_time = spawn_delay
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)

# ========
# signal handler
# ========

func _on_wave_incoming_timer_timeout() -> void:
	""" when the incoming wave timer has expired """

	# start the timer for the next wave
	current_wave = incoming_wave
	incoming_wave += 1
	if len(waves) > incoming_wave:
		wave_incoming.emit(incoming_wave)
		if _game_events:
			_game_events.wave_incoming.emit(waves[incoming_wave].start_delay, current_wave, incoming_wave, len(waves))

	# emit wave started signal 
	wave_started.emit(current_wave)

func _on_spawn_timer_timeout() -> void:

	print("===============================")
	print("timeout for spawener")
	print("current_wave: " + str(current_wave))
	print("range: " + str(range(0, current_wave)))

	# loop trough preloaded enemies array up to the current wave
	for i in range(0, current_wave+1):
		print("in loop, preloaded enemies pwer wave: " + str(i) + " - " + str(preloaded_enemies_per_wave[i]))
		var enemy = preloaded_enemies_per_wave[i].pop_front()
		if enemy:
			enemy_placement_node.add_child(enemy)
			return

func _on_enemy_decrease_wave_count(wave_id: int) -> void:
	""" called when an enemy object is removed from the scene tree, ensure the count of 'alive' enemies is reduced """

	print("###################################")
	print("_on_enemy_ecrese: " + str(wave_id))

	enemies_per_wave_count[wave_id] -= 1

	if enemies_per_wave_count[wave_id] <= 0:
		if _game_events:
			_game_events.wave_defeated.emit(wave_id)


func _on_wave_incoming(wave_id: int) -> void:
	""" incoming wave, set wait timer and preload enemy scenes """
	incoming_wave = wave_id
	
	if not wave_incoming_timer:
		print_debug("no incoming timer found")
		return

	wave_incoming_timer.wait_time = waves[wave_id].start_delay
	wave_incoming_timer.start()

	# preload all enemies for the incoming wave
	# store all preloaded enemies in a nested array
	# to allow the spawner to only spawn enemies which wave has started
	var spawn_position_to_use = last_used_spawn_tile_position
	var preloaded_enemies: Array[Ufo] = []
	for g in waves[wave_id].spawn_groups:
		spawn_position_to_use +=1 
		if len(spawn_tile_positiions) <= spawn_position_to_use:
			spawn_position_to_use = 0

		for e in g.entities:
			var e_scene = e.instantiate()
			e_scene.position = spawn_tile_positiions[spawn_position_to_use]
			e_scene.wave_id = incoming_wave
			if e_scene.has_signal("decrease_wave_count"):
				e_scene.decrease_wave_count.connect(_on_enemy_decrease_wave_count)
			preloaded_enemies.append(e_scene as Ufo)
	preloaded_enemies_per_wave.append(preloaded_enemies)
	# store the count of the preloaded enemies for the wave. this number will be decresed each
	# time one of the ufos of the wave is destroyed
	enemies_per_wave_count.append(len(preloaded_enemies))

	# store the last spawn position so the next group in the next wave can start from the next one
	last_used_spawn_tile_position = spawn_position_to_use
		

func _on_wave_started(wave_id: int) -> void:
	
	# first pass signal to game events for other systems to react
	if _game_events:
		_game_events.wave_started.emit(wave_id)

	# and now lets beginn spawning in the enemies
	spawn_timer.start()

# ========
# class functions
# ========

func _enter_game_loop() -> void:
	unload_spawn_positions()
	load_spawn_positions()	

	unload_waves()
	load_waves()

	unload_placement_node()
	load_placement_node()


func _game_loop() -> void:
	if initial_wave_started:
		return

	run_initial_wave()
	initial_wave_started = true

func load_spawn_positions() -> void:
	""" load the spawn positions available in the level """
	self.spawn_tile_positiions = level_manager.get_floor().spawn_tile_positions

func unload_spawn_positions() -> void:
	self.spawn_tile_positiions = []

func load_waves() -> void: 
	""" load the wave data from the selected level """
	
	self.waves = _game_data.selected_floor.waves

func load_placement_node() -> void:
	self.enemy_placement_node = level_manager.get_floor().enemies

func unload_placement_node() -> void:
	self.enemy_placement_node = null

func unload_waves() -> void: 
	""" unload stored wave data """
	self.initial_wave_started = false
	self.waves = []
	self.current_wave = -1
	self.incoming_wave = 0
	self.last_used_spawn_tile_position = -1
	self.preloaded_enemies_per_wave = []
	self.enemies_per_wave_count = []

	if wave_incoming_timer:
		wave_incoming_timer.stop()
	if spawn_timer:
		spawn_timer.stop()


func run_initial_wave() -> void:
	""" run the current wave """

	if len(waves) <= 0:
		print_debug('no waves found')
		return
	
	# start initial wave !
	wave_incoming.emit(incoming_wave)
	# also instruct game events that this is happening to setup ui etc
	if _game_events:
		_game_events.wave_incoming.emit(waves[incoming_wave].start_delay, 0, 0, len(waves))
