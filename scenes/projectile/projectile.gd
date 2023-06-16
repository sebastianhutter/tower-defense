extends Area2D
class_name Projectile

# ========
# singleton references
# ========

# ========
# export vars
# ========

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

# ========
# godot functions
# ========

func _ready() -> void:
    print('eriopgnoipergniognioerngio')
    if expiry_timer:
        print("timer found")
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
    print("_on_expiry_timer)")
    if animation_player:
        if animation_player.has_animation("expired"):
            animation_player.play("expired")
            await animation_player.animation_finished
    
    queue_free()


# ========
# class functions
# ========

func set_target_position(pos: Vector2) -> void:
    target_position = pos

func set_damage_modifier(modifier: float) -> void:
    if not hitbox_component:
        return

    hitbox_component.damage *= modifier
