extends Node2D

# connect to Game UI
@onready var user_interface = $UserInterface

var current_state: int = game_state.prep_phase
var team: Array[Node2D] = []
var enemies: Array[Node2D] = []

var current_member: int = 0
var target_enemy: int = 0

enum game_state{
	prep_phase,
	target,
	queue,
	battle_phase
}


func _ready():
	for member in get_tree().get_nodes_in_group("entities"):
		if member.in_team:
			team.append(member)
		else:
			enemies.append(member)
			


func _process(delta):
	if current_state == game_state.prep_phase and current_member < team.size():
		user_interface.skill_ui_update(team[current_member])
		pass
		
	elif current_state == game_state.target:
#		pick enemy/ally
		pass
	elif current_state == game_state.queue:
#		
		pass
	elif current_state == game_state.battle_phase:
		pass
