extends CanvasLayer
class_name WaveUi

# ========
# singleton references
# ========

# ========
# export vars
# ========

# ========
# class signals
# ========

# ========
# class onready vars
# ========

@onready var wave_counter_label: Label = $%WaveCounterLabel
@onready var wave_timer_bar: ProgressBar = $%WaveTimerBar
@onready var wave_timer: Timer = $%WaveTimer

# ========
# class vars
# ========

var current_wave: int = 0: 
	get:
		return current_wave
	set(value):
		current_wave = value
		set_wave_counter()

var wave_count: int = 0:
	get:
		return wave_count
	set(value):
		wave_count = value
		set_wave_counter()

# ========
# godot functions
# ========

func _ready():
	wave_timer.timeout.connect(_on_timer_timeout)


func _physics_process(_delta: float) -> void:
	if wave_timer.is_stopped():
		return

	wave_timer_bar.value = 1 - wave_timer.time_left / wave_timer.wait_time


# ========
# signal handler
# ========

func _on_timer_timeout():
	wave_timer_bar.value = 0

# ========
# class functions
# ========

func set_wave_counter() -> void:
	wave_counter_label.text = str(current_wave) + " / " + str(wave_count)

func set_timer(time: float) -> void:
	wave_timer.wait_time = time

func start_timer() -> void:
	if not wave_timer.is_stopped():
		print_debug("WaveUi: timer already running")
		return 
	
	wave_timer.start()

