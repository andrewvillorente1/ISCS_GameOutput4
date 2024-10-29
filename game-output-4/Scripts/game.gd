extends Node2D
@onready var user_interface: CanvasLayer = $UserInterface

 
var current_state: int = game_state.prep_phase
var team: Array[Node2D] = []
var enemies: Array[Node2D] = []
var atk_panels: GridContainer
var turn: Label
var feedback: Label

var current_member: int = 0
var target_enemy: int = 0

signal skill_button_pressed(skill_number: int)

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

	atk_panels = user_interface.get_child(0).get_child(0)
	turn = user_interface.get_child(1).get_child(0)
	feedback = user_interface.get_child(0).get_child(1)
	
	atk_panels.set_visible(false)
	turn.set_visible(false)
	feedback.set_visible(false)
	
	current_member = 2
	
	atk_panels.columns = team[current_member].skill_num
	for i in team[current_member].skill_num:

		var button = Button.new()
		button.text = team[current_member].skill_names(i)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		button.anchor_left = 0.5
		button.anchor_right = 0.5
		button.anchor_top = 0.5
		button.anchor_bottom = 0.5
		atk_panels.add_child(button)

		#button.pressed.connect(team[current_member].skill_set)

func _process(delta):
	if current_state == game_state.prep_phase and current_member < team.size():

		#for existing_child in atk_panels.get_children():
			#existing_child.queue_free()
		
		atk_panels.set_visible(true)
		#for i in team[current_member].skill_num:
##			this goes thru each skill of the current member 
			#var panel = Panel.new()
			#panel.size_flags_horizontal = Control.SIZE_FILL | Control.SIZE_EXPAND
			#
			#var button = Button.new()
			#button.text = team[current_member].skill_names(i)
			#panel.add_child(button)
			#
			#button.pressed.connect(team[current_member].skill_set)
		#current_member += 1
		
		
	elif current_state == game_state.target:
#		pick enemy/ally
		pass
	elif current_state == game_state.queue:
#		
		pass
	elif current_state == game_state.battle_phase:
#		
		pass
