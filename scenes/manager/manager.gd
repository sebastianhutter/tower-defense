extends Node
class_name Manager

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

# ========
# class vars
# ========

# ========
# godot functions
# ========

# ========
# signal handler
# ========

# ========
# class functions
# ========

func _quit_game() -> void:
    """ called when quit_game is entered"""
    pass

func _menu_loop(menu: Types.Menu) -> void:
    """ called when menu_loop is entered """
    pass

func _enter_game_loop() -> void:
    """ called when enter_game_loop is entered """
    pass

func _exit_game_loop() -> void:
    """ called when exit_game_loop is entered """
    pass

func _game_loop() -> void:
    """ called when game_loop is entered """
    pass

func _game_over() -> void:
    """ called when game_over is entered """
    pass