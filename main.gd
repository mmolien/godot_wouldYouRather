extends Node

# UI elements
@onready var prompt_label = $Control/VBoxContainer/TXT_PROMPT
@onready var giant_button = $Control/VBoxContainer/HBoxContainer/BTN_GIANT
@onready var swarm_button = $Control/VBoxContainer/HBoxContainer/BTN_SWARM
@onready var result_label = $Control/VBoxContainer/TXT_RESULT
@onready var play_again_button = $Control/VBoxContainer/BTN_RETRY
@onready var health_player = $Control/VBoxContainer/HEALTH_PLAYER
@onready var health_monster = $Control/VBoxContainer/HEALTH_MONSTER

# Creature stats (using a Dictionary for demonstration)
var giant_creature = {"health": 100, 	"attack": 15 	}
var small_creature = {"health": 5, 		"attack": 1 	}
var player_default = {"health": 100, 	"attack": 15 	}

# Game State variables
var player_health = player_default.health
var player_attack = player_default.attack


func _ready():
	reset_game()

func reset_game():
	health_player.value = player_default.health
	prompt_label.text = "Would you rather ..."
	result_label.text = ""
	giant_button.show()
	swarm_button.show()
	play_again_button.hide()
	health_monster.show()

func fight_giant_creature():
	var creature_health = giant_creature.health
	var current_player_health = player_default.health

	health_monster.max_value = giant_creature.health
	health_monster.value = creature_health
	health_monster.show()

	while current_player_health > 0 and creature_health > 0:
		var player_damage = player_attack + randi_range(-5, 5)
		creature_health -= player_damage
		health_monster.value = creature_health

		var creature_damage = giant_creature.attack + randi_range(-10, 10)
		current_player_health -= creature_damage
		health_player.value = current_player_health
		await Engine.get_main_loop().process_frame

	if current_player_health > 0:
		end_game("VICTORY! You have defeated the Giant Creature!")
	else:
		end_game("DEFEAT! The giant creature has crushed you.")

func fight_small_creatures():
	var remaining_creatures = 100
	var current_player_health = player_default.health

	while current_player_health > 0 and remaining_creatures > 0:
		var player_damage = ( player_attack + randi_range(0, 5) )
		var dead_this_turn = mini( remaining_creatures, int( ( player_damage / 3 ) + 1 ) )
		remaining_creatures -= dead_this_turn
		health_monster.value = remaining_creatures

		var total_creature_damage = round( int( remaining_creatures / 5 ) + randi_range(0, 10) )
		current_player_health -= total_creature_damage
		health_player.value = current_player_health
		await Engine.get_main_loop().process_frame

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
