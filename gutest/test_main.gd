# The test script must extend the GutTest class.
extends GutTest

# A variable to hold the instance of the script we are testing.
var main_script
var main_scene: main

# This function runs before each test method.
func before_each():
	# Instantiate the main.gd script so we can access its functions.
	main_script = load("res://main.gd").new()
	main_scene = load("res://main.tscn").instantiate()

	add_child(main_scene)
	await wait_for_signal( main_scene.ready, 5, "Scene to test failed load.")


# This function runs after each test method.
func after_each():
	# Clean up any objects to prevent memory leaks.
	if main_script:
		main_script.free()
	if main_scene:
		main_scene.free()


# Test that the reset_game function works correctly.
func test_reset_game_initializes_player_health():
	# Simulate a battle ending by changing the player's health.
	main_script.player_health = 50
	
	# Call the function to be tested.
	main_script.reset_game()
	#main_script.player_health = 100
	
	# Assert that the player's health has been reset to its initial value.
	assert_eq(main_script.player_health, 100, "Player health should be 100 after reset.")


# Test a single, powerful creature fight.
func test_fight_giant_creature_simulates_battle():
	# This is an integration test of the combat simulation logic.
	# We can't predict the outcome due to the random elements.
	# Instead, we can verify that the game state changes.
	
	main_script.fight_giant_creature()
	var _tmp_text = ""
	if(main_script.result_label):
		_tmp_text = main_script.result_label.text
	# The battle should end, so result_label.text will no longer be empty.
	assert_ne( _tmp_text, "", "Battle should produce a result message.")
	
	var _button_visible1 = true
	var _button_visible2 = true
	var _button_visible3 = false

	if(main_script.giant_button):
		_button_visible1 = main_script.giant_button.is_visible()
	assert_false( _button_visible1, "Giant button should be hidden after battle.")

	if(main_script.swarm_button):
		_button_visible2 = main_script.swarm_button.is_visible()
	assert_false( _button_visible2, "Swarm button should be hidden after battle.")
	
	if(main_script.retry_button):
		_button_visible3 = main_script.retry_button.is_visible()
	# The play again button should be visible.
	assert_true( _button_visible3, "Play Again button should be visible after battle.")


# Test a swarm of smaller creatures fight.
func test_fight_small_creatures_simulates_battle():
	main_script.fight_small_creatures()

	var _tmp_text = ""
	if(main_script.result_label):
		_tmp_text = main_script.result_label.text
	# The battle should end, so result_label.text will no longer be empty.
	assert_ne( _tmp_text, "", "Battle should produce a result message.")
	
	var _button_visible1 = true
	var _button_visible2 = true
	var _button_visible3 = false

	if(main_script.giant_button):
		_button_visible1 = main_script.giant_button.is_visible()
	assert_false( _button_visible1, "Giant button should be hidden after battle.")

	if(main_script.swarm_button):
		_button_visible2 = main_script.swarm_button.is_visible()
	assert_false( _button_visible2, "Swarm button should be hidden after battle.")
	
	if(main_script.retry_button):
		_button_visible3 = main_script.retry_button.is_visible()
	# The play again button should be visible.
	assert_true( _button_visible3, "Play Again button should be visible after battle.")
