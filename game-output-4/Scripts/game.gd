extends Node2D
@onready var user_interface: CanvasLayer = $UserInterface


var current_state: int = game_state.prep_phase
var team: Array[Node2D] = []
var enemies: Array[Node2D] = []
var atk_panels: Array[GridContainer] = []
var turn: Label
var feedback: Label
var target_panel_enemy: GridContainer
var target_panel_ally: GridContainer
var target_panel: Panel
var spawned: bool = false
var selected_skill: int = 0

var current_member: int = 0
var target_enemy: int = 0
var target_array: int
var action_value_dict: Dictionary = {}
var sorted_action_value: Array = []

# signals: 0 if target enemy, 1 if target ally, 2 if target self

enum game_state{
	prep_phase,
	target,
	queue,
	battle_phase
}


func _ready():

	turn = user_interface.get_child(1).get_child(0)
	feedback = user_interface.get_child(0).get_child(3)
	target_panel_ally = user_interface.get_child(2).get_child(0)
	target_panel_enemy = user_interface.get_child(2).get_child(1)
	target_panel = user_interface.get_child(2)

	for member in get_tree().get_nodes_in_group("entities"):
		if member.in_team:
			team.append(member)
			var button = Button.new()
			button.text = member.unit_name
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			button.size_flags_vertical = Control.SIZE_EXPAND_FILL
			button.anchor_left = 0
			button.anchor_right = 1
			button.anchor_top = 0
			button.anchor_bottom = 1
			button.set_toggle_mode(true)
			button.pressed.connect(self._target)
			target_panel_ally.add_child(button)
		else:
			enemies.append(member)
			var button = Button.new()
			button.text = member.unit_name
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			button.size_flags_vertical = Control.SIZE_EXPAND_FILL
			button.anchor_left = 0
			button.anchor_right = 1
			button.anchor_top = 0
			button.anchor_bottom = 1
			button.set_toggle_mode(true)
			button.pressed.connect(self._target)
			target_panel_enemy.add_child(button)

	for e in get_tree().get_nodes_in_group("entities"):
		e.skill_target.connect(initailize_targets)

	for i in team.size():
		atk_panels.append(user_interface.get_child(0).get_child(i))
		atk_panels[i].set_visible(false)
	
	turn.set_visible(false)
	feedback.set_visible(false)
	target_panel_ally.set_visible(false)
	target_panel_enemy.set_visible(false)
	target_panel.set_visible(false)
	
	while current_member < team.size():
		for child in atk_panels[current_member].get_children(): 
			child.queue_free()
		
		atk_panels[current_member].columns = team[current_member].skill_num
		for i in team[current_member].skill_num:
			var button = Button.new()
			button.text = team[current_member].skill_names(i)
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			button.size_flags_vertical = Control.SIZE_EXPAND_FILL
			button.anchor_left = 0
			button.anchor_right = 1
			button.anchor_top = 0
			button.anchor_bottom = 1
			button.set_toggle_mode(true)

			button.pressed.connect(self._action)
			atk_panels[current_member].add_child(button)
		current_member += 1
	current_member = 0

func _action():
	current_state = game_state.target
	
	for x in team.size():
		if x == current_member:
			var index: int
			for i in atk_panels[current_member].get_children():
				if i.is_pressed():
					index = atk_panels[current_member].get_children().find(i)
					selected_skill = index
			team[current_member].skill_signal(index)
				

func initailize_targets(skill_type: int):
	target_panel.set_visible(true)
	target_array = skill_type
	if skill_type == 0:
		target_panel_ally.set_visible(false)
		target_panel_enemy.set_visible(true)
	elif skill_type == 1:
		target_panel_ally.set_visible(true)
		target_panel_enemy.set_visible(false)
	else:
		target_panel_ally.set_visible(false)
		target_panel_enemy.set_visible(false)
		target_panel.set_visible(false)
		_target()

func add_to_action_dict(node: Node, array: Array):
	action_value_dict[node] = array

func _target():
	current_state = game_state.queue
	if target_array == 0:
		for enemy in target_panel_enemy.get_children():
			if enemy.is_pressed():
				add_to_action_dict(team[current_member], [selected_skill, enemy.text])
	elif target_array == 1:
		for member in target_panel_ally.get_children():
			if member.is_pressed():
				add_to_action_dict(team[current_member], [selected_skill, member.text])
	else:
		add_to_action_dict(team[current_member], [selected_skill])

	atk_panels[current_member].set_visible(false)
	target_panel_ally.set_visible(false)
	target_panel_enemy.set_visible(false)
	target_panel.set_visible(false)
	spawned = false
	if current_member < 2:
		current_member += 1
		current_state = game_state.prep_phase
	else:
		for enemy in enemies:
			var ran_skill = randi_range(0, enemy.skill_num-1)
			if (ran_skill == 1)  && (enemy.unit_name.contains("Archer") or enemy.unit_name.contains("Warrior")):
				add_to_action_dict(enemy, [ran_skill])
			elif (ran_skill == 1) && (enemy.unit_name.contains("Mage") or enemy.unit_name.contains("Tank")):
				add_to_action_dict(enemy, [ran_skill, enemies[randi_range(0, enemies.size()-1)]])
			else:
				add_to_action_dict(enemy, [ran_skill, team[randi_range(0, team.size()-1)]])
		current_member = 0
		print(action_value_dict)

func _input(event):
	if current_state == game_state.target and event.is_action_pressed("ui_cancel"):
		target_panel.set_visible(false)
		current_state = game_state.prep_phase

func _process(delta):
	if current_state == game_state.prep_phase and current_member < team.size():
		
		if !spawned:
			target_panel_ally.set_visible(false)
			target_panel_enemy.set_visible(false)
			for i in team.size():
				atk_panels[i].set_visible(false)
			atk_panels[current_member].set_visible(true)
			spawned = true
		
		for b in atk_panels[current_member].get_children():
			b.set_mouse_filter(0)
			b.set_pressed_no_signal(false)
		
	elif current_state == game_state.target:
		for b in atk_panels[current_member].get_children():
			b.set_mouse_filter(2)
		
	elif current_state == game_state.queue:

#		not yet working	
		#sorted_action_value = []
		#var keys = action_value_dict.keys()
		#keys.sort_custom(func(a, b): return int(b.speed - a.speed))
		#for node in keys:
			##sorted_action_value.append({node: action_value_dict[node]})
			#sorted_action_value.append({node: node.speed})
		
		
#	last part: untoggle everything
		for atk in atk_panels[current_member].get_children():
			atk.set_pressed(false)
		for enemy in target_panel_enemy.get_children():
			enemy.set_pressed(false)
		for member in target_panel_ally.get_children():
			member.set_pressed(false)
		
		current_state = game_state.battle_phase
		#print(sorted_action_value)

	elif current_state == game_state.battle_phase:
#		
		pass
