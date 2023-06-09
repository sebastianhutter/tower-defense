# GdUnit generated TestSuite
class_name GameEventsTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://library/autoload/game_events.gd'

var game_events: GameEvents


func before_test() -> void:
	"""initialize resources for testing"""

	game_events = auto_free(GameEvents.new())
	

func test_ensure_signals_are_registered() -> void:
	"""ensure the game events singleton has all signals registered"""
	
	assert_signal(game_events).is_signal_exists("game_state_changed")
	assert_signal(game_events).is_signal_exists("ability_activated")
	assert_signal(game_events).is_signal_exists("ability_recovery_started")
	assert_signal(game_events).is_signal_exists("ability_recovery_complete")

# TODO: check signal emition after next gdunit4 release
# https://github.com/users/MikeSchulze/projects/5/views/6?pane=issue&itemId=19139780
