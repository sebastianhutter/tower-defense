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
	assert_signal(game_events).is_signal_exists("tower_card_clicked")
	assert_signal(game_events).is_signal_exists("tower_build_started")
	assert_signal(game_events).is_signal_exists("tower_build_completed")
	assert_signal(game_events).is_signal_exists("tower_build_completed")
	assert_signal(game_events).is_signal_exists("tower_upgrade_started")
	assert_signal(game_events).is_signal_exists("tower_sold")
	assert_signal(game_events).is_signal_exists("tower_destroyed")
	assert_signal(game_events).is_signal_exists("tower_clicked")
	assert_signal(game_events).is_signal_exists("tower_context_menu_upgrade_button_clicked")
	assert_signal(game_events).is_signal_exists("tower_context_menu_sell_button_clicked")
	assert_signal(game_events).is_signal_exists("wave_incoming")
	assert_signal(game_events).is_signal_exists("wave_started")
	assert_signal(game_events).is_signal_exists("wave_defeated")
	assert_signal(game_events).is_signal_exists("send_wave")
	assert_signal(game_events).is_signal_exists("increase_gold")
	assert_signal(game_events).is_signal_exists("hq_hit")
