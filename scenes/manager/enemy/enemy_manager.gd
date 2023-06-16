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

var spawn_tile_positiions: Array[Vector2]
var waves: Array[WaveResource]
var current_wave: int = 0
var incoming_wave: int = 0

var enemy_placement_node: Node2D
var last_used_spawn_tile_position: int = -1
var enemies: Array[Ufo]



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

	var enemy = enemies.pop_front()
	if not enemy:
		# TODO: emit event wave finished?
		return

	enemy_placement_node.add_child(enemy)


func _on_wave_incoming(wave_id: int) -> void:
	""" incoming wave, set wait timer and preload enemy scenes """
	incoming_wave = wave_id
	
	if not wave_incoming_timer:
		print_debug("no incoming timer found")
		return

	wave_incoming_timer.wait_time = waves[wave_id].start_delay
	wave_incoming_timer.start()

	# preload all enemies for the incoming wave
	var spawn_position_to_use = last_used_spawn_tile_position
	for g in waves[wave_id].spawn_groups:
		spawn_position_to_use +=1 
		if len(spawn_tile_positiions) <= spawn_position_to_use:
			spawn_position_to_use = 0
		print(spawn_position_to_use)
		
		for e in g.entities:
			var e_scene = e.instantiate()
			e_scene.position = spawn_tile_positiions[spawn_position_to_use]
			enemies.append(e_scene as Ufo)

	# store the last spawn position so the next group in the next wave can start from the next one
	last_used_spawn_tile_position = spawn_position_to_use
		

func _on_wave_started(wave_id: int) -> void:
	
	# first pass signal to game events for other systems to react
	if _game_events:
		_game_events.wave_started.emit(wave_id)

	# and now lets beginn spawning in the enemies
	spawn_timer.start()


	# TODO: store enemy per wave in array
	# TODO: store "free for spawning" bool per wave
	# TODO: emit signal after all when all enemies in wave are done and dusted?



# ========
# class functions
# ========

func _enter_game_loop() -> void:
	unload_spawn_positions()
	load_spawn_positions()	

	unload_waves()
	load_waves()

	if self.enemy_placement_node != null:
		self.enemy_placement_node = null
	self.enemy_placement_node = level_manager.get_floor().enemies
		


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
	self.current_wave = -1
	self.incoming_wave = 0
	self.last_used_spawn_tile_position = -1
	self.enemies = []

	if wave_incoming_timer:
		wave_incoming_timer.stop()
	if spawn_timer:
		spawn_timer.stop()

func run_wave() -> void:
	""" run the current wave """

	if len(waves) <= 0:
		print_debug('no waves found')
		return
	
	wave_incoming.emit(incoming_wave)
	# also instruct game events that this is happening to setup ui etc
	if _game_events:
		_game_events.wave_incoming.emit(waves[incoming_wave].start_delay, current_wave, incoming_wave, len(waves))
