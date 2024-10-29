extends Node2D
@onready var user_interface: CanvasLayer = $UserInterface

 
var current_state: int = game_state.prep_phase
var team: Array[Node2D] = []
var enemies: Array[Node2D] = []
var atk_panels: GridContainer
var turn: Label
var feedback: Label

var button

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
	update_ui()


func _process(delta):
	if current_state == game_state.prep_phase and current_member < team.size():
		pass

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
		
func choose_skill():
	# identify what skill was chosen
	
	#var chosen_skill = team[current_member].skill_names(choice_num)
	#
	#if chosen_skill == "attack":
		#print("test attack")
	#elif chosen_skill == "enhance crit":
		#print("test enhance crit")
	#elif chosen_skill == "sleep":
		#print("test sleep")
	#elif chosen_skill == "poison":
		#print("test poison")
	#elif chosen_skill == "heal":
		#print("test heal")
	#elif chosen_skill == "defend":
		#print("test defend")
	#elif chosen_skill == "enhance attack":	
		#print("test enhance attack")
	
	# move pointer to next player character
	if current_member < (team.size()-1):
		current_member += 1
	else:
		current_member = 0
	
	# clear previous skills displayed
	for existing_child in atk_panels.get_children():
			existing_child.queue_free()
	
	# update ui with current character's skills
	update_ui()
	
	

func update_ui():
	atk_panels = user_interface.get_child(0).get_child(0)
	turn = user_interface.get_child(1).get_child(0)
	feedback = user_interface.get_child(0).get_child(1)
	
	atk_panels.set_visible(false)
	turn.set_visible(false)
	feedback.set_visible(false)
	
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
		button.pressed.connect(self.choose_skill) # choose_skill function
		atk_panels.add_child(button)
	
	# make panels visible
	atk_panels.set_visible(true)
