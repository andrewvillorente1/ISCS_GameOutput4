# --------------------------------------------------------------------
# REMINDERS
# - ADD A If Condition for the Warrior/Tank skill multiplier so you can't use it more than one per game. 
# - Currently, the multiplier counters for Warrior/Tank aren't being reset once they reach x turns. Meaning, you can only really get the buff once, although there's no logic at present stopping you from choosing that in your
#   turn at the present.
#
#
# --------------------------------------------------------------------

extends Node2D


var warrior
var mage
var archer
var last_key_press_time = 0.0  # Variable to store the last key press time
const COOLDOWN_TIME = 2.0  # Cooldown time in seconds

func _ready():
	warrior = get_node("WarriorUnit")
	mage = get_node("MageUnit")
	archer = get_node("ArcherUnit")
	

func _process(delta):
	# Check for the current time
	var current_time_dict = Time.get_time_dict_from_system()
	var current_time = current_time_dict["hour"] * 3600 + current_time_dict["minute"] * 60 + current_time_dict["second"]

	# Check for UP key press
	if Input.is_action_pressed("ui_up"):
		if (current_time - last_key_press_time) >= COOLDOWN_TIME:
			print("UP key is pressed!")  # Handle W key action here
			var damage_dealt = warrior.attack(1)  # Call attack function from the warrior instance
			mage.take_damage(damage_dealt)  # Deal damage to the mage
			last_key_press_time = current_time  # Update the last key press time

	# Check for LEFT arrow key press
	if Input.is_action_pressed("ui_left"):
		if (current_time - last_key_press_time) >= COOLDOWN_TIME:
			print("LEFT key is pressed!")  # Handle W key action here
			var damage_heal = mage.heal()
			warrior.add_health(damage_heal) #Heal warrior
			last_key_press_time = current_time  # Update the last key press time

	if Input.is_action_pressed("ui_down"):
		if (current_time - last_key_press_time) >= COOLDOWN_TIME:
			print("DOWN key is pressed!")  # Handle W key action here
			var damage_dealt2 = archer.attack(2)  # Call attack function from the warrior instance
			mage.take_damage(damage_dealt2)  # Deal damage to the mage
			last_key_press_time = current_time  # Update the last key press time

	if Input.is_action_pressed("ui_right"):
		if (current_time - last_key_press_time) >= COOLDOWN_TIME:
			print("RIGHT key is pressed!")  # Handle W key action here
			var debuff = mage.send_debuff()
			archer.receive_debuff(debuff) #send a debuff to archer
			last_key_press_time = current_time  # Update the last key press time
