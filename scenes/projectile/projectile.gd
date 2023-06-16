extends Area2D
class_name Projectile

# ========
# singleton references
# ========

# ========
# export vars
# ========

@export var max_hits: int = 1
@export var speed: float = 100.0

# ========
# class signals
# ========

# ========
# class onready vars
# ========

@onready var expiry_timer: Timer = $%Timer
@onready var animation_player: AnimationPlayer = $%AnimationPlayer
@onready var hitbox_component: HitboxComponent = $%HitboxComponent

# ========
# class vars
# ========

var target_position: Vector2 = Vector2.ZERO
var hit_count: int = 0 :
    get:
        return hit_count
    set(value):
        hit_count = value
        if hit_count >= max_hits:
            stop_projectil()

# ========
# godot functions
# ========

func _ready() -> void:
    if expiry_timer:
        expiry_timer.timeout.connect(_on_expiry_timer_timeout)
        expiry_timer.start()


func _physics_process(delta):
    if target_position == Vector2.ZERO:
        return

    position += transform.x * speed * delta

# ========
# signal handler
# ========

func _on_expiry_timer_timeout() -> void:
    stop_projectil()

# ========
# class functions
# ========

func set_target_position(pos: Vector2) -> void:
    target_position = pos

func set_damage_modifier(modifier: float) -> void:
    if not hitbox_component:
        return

    hitbox_component.damage *= modifier

func stop_projectil() -> void:
    """ stop the projectil either after timeout or after max hit count is reached """
    if animation_player:
        if animation_player.has_animation("expired"):
            animation_player.play("expired")
            await animation_player.animation_finished
    
    queue_free()
