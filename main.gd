extends Node

# Game State variables
var player_health = 100
var player_attack = 15

# UI elements
@onready var prompt_label = $Control/VBoxContainer/TXT_PROMPT
@onready var giant_button = $Control/VBoxContainer/HBoxContainer/BTN_GIANT
@onready var swarm_button = $Control/VBoxContainer/HBoxContainer/BTN_SWARM
@onready var result_label = $Control/VBoxContainer/Result
@onready var play_again_button = $Control/VBoxContainer/BTN_RETRY

# Creature stats (using a Dictionary for demonstration)
var giant_creature = {"health": 250, "attack": 30}
var small_creature = {"health": 5, "attack": 1}

func _ready():
	reset_game()

func reset_game():
	player_health = 100
	prompt_label.text = "Would you rather ..."
	result_label.text = ""
	giant_button.show()
	swarm_button.show()
	play_again_button.hide()

func fight_giant_creature():
	var creature_health = giant_creature.health
	var current_player_health = player_health

	while current_player_health > 0 and creature_health > 0:
		var player_damage = player_attack + randi_range(-5, 5)
		creature_health -= player_damage

		var creature_damage = giant_creature.attack + randi_range(-10, 10)
		current_player_health -= creature_damage

	if current_player_health > 0:
		end_game("VICTORY! You have defeated the Giant Creature!")
	else:
		end_game("DEFEAT! The giant creature has crushed you.")

func fight_small_creatures():
	var remaining_creatures = 100
	var current_player_health = player_health

	while current_player_health > 0 and remaining_creatures > 0:
		var player_damage = player_attack + randi_range(0, 5)
		var dead_this_turn = mini(remaining_creatures, int(player_damage / 3) + 1)
		remaining_creatures -= dead_this_turn

		var total_creature_damage = int(remaining_creatures / 5) + randi_range(0, 10)
		current_player_health -= total_creature_damage

	if current_player_health > 0:
		end_game("VICTORY! You have survived the swarm and emerged victorious!")
	else:
		end_game("DEFEAT! The endless swarm has overwhelmed you.")

func end_game(message):
	result_label.text = message
	prompt_label.text = "Battle Complete!"
	giant_button.hide()
	swarm_button.hide()
	play_again_button.show()


func _on_btn_giant_pressed() -> void:
	prompt_label.text = "You chose to fight the One Giant Creature!"
	fight_giant_creature()
	pass # Replace with function body.


func _on_btn_swarm_pressed() -> void:
	prompt_label.text = "You chose to fight the One Hundred Smaller Creatures!"
	fight_small_creatures()
	pass # Replace with function body.


func _on_btn_retry_pressed() -> void:
	reset_game()
	pass # Replace with function body.
