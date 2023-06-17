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
@onready var send_wave_button: Button = $%SendWaveButton

# ========
# class vars
# ========

var current_wave: int = 0: 
	get:
		return current_wave
	set(value):
		current_wave = value
		set_wave_counter()
		set_wave_progress_bar()
		set_send_wave_button()

var wave_count: int = 0:
	get:
		return wave_count
	set(value):
		wave_count = value
		set_wave_counter()
		set_wave_progress_bar()
		set_send_wave_button()

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

func reset_counters() -> void:
	self.current_wave = 0
	self.wave_count = 0
	if wave_timer:
		wave_timer.stop()

func set_wave_counter() -> void:
	wave_counter_label.text = "Wave: " + str(current_wave) + " / " + str(wave_count)

func start_timer(time: float) -> void:
	wave_timer.start(time)

func set_wave_progress_bar() -> void:
	if current_wave < wave_count:
		return

	wave_timer_bar.value = 0
	wave_timer.stop()

func set_send_wave_button() -> void:

	if current_wave < wave_count:
		send_wave_button.disabled = false
		return

	send_wave_button.disabled = true