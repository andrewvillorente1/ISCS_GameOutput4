extends Node2D

var skill_set: Array[String] = []

func _ready(): 
	var window_size = get_viewport_rect().size # static window size == ui elements anchor
	
func skill_ui_update(character: Node2D):
	# !!! handle deletion of previous character's skill buttons !!!
	
	# Identify what skills does the current character has
	if character.has_method("attack"):
		skill_set.append("Attack")
	if character.has_method("enhance_crit"):
		skill_set.append("Enhance Crit")
	if character.has_method("sleep"):
		skill_set.append("Sleep")
	if character.has_method("poison"):
		skill_set.append("Poison")
	if character.has_method("heal"):
		skill_set.append("Heal")
	if character.has_method("defend"):
		skill_set.append("Defend")
	if character.has_method("enhance_attack"):
		skill_set.append("Enhance Attack")
	
	var button_horizontal_position = 0
	var button_horizontal_spacing = 50
	
	# Create a new button node for each skill
	for skill in skill_set:
		var button = Button.new()
		# Set button
		button.text = skill
		button.position = Vector2(button_horizontal_position, 100)
		button.size = Vector2(1, 30)
		# Add the button to the scene tree
		add_child(button)
		
		button_horizontal_position += button_horizontal_spacing
