extends Node2D

var health = 120
var multiplier_counter = 0
var attack_multiplier = 1
var debuff_turn_counter = 0
var is_animating = false
@onready var animated_sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_animating:  # Only play idle if no other animation is playing
		animated_sprite.play("idle")

# Single attack function with an integer determining the type of attack
func attack(attack_type: int) -> int:
	multiplier_counter += 1
	var attack_1_damage = 40 * attack_multiplier
	var attack_2_damage = 50 * attack_multiplier
	var attack_3_damage = 60 * attack_multiplier
	match attack_type:
		1:
			play_animation("warrior_attack_1")
			return attack_1_damage  # You can apply the damage after the animation is done
		2:
			play_animation("warrior_attack_2")
			return attack_2_damage
		3:
			play_animation("warrior_attack_3")
			return attack_3_damage
		_:
			print("Invalid attack type")
			return 0

func defend():
	play_animation("warrior_defend_1")

func skill_multiplier():
	if multiplier_counter < 4:
		attack_multiplier = 1.25

func return_multiplier_count() -> int:
	return multiplier_counter
	
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func get_poisoned(amount: int):
	play_animation("warrior_poisoned")
	for i in range (10): #The reason why it's in a for loop is because we can have a timer after health is reduced so in the Game scene, assuming there's a live view of unit health, we'll see health being minused slowly
		health -= amount
	if health <= 0:
		die()

func receive_debuff(amount: int): #Nothing happens ATM for the receive debuff because logic should be in game.gd script. However, function is present here because 
	debuff_turn_counter = amount

func minus_debuff_count():
	debuff_turn_counter -= 1

func debuff_count() -> int:
	return debuff_turn_counter

func add_health(add_health: int) -> void:
	health += add_health

func die():
	print("Warrior has been defeated!")
	queue_free()

func play_animation(animation_name: String) -> void:
	is_animating = true
	animated_sprite.play(animation_name)
	await animated_sprite.animation_finished  # Await the end of the animation
	is_animating = false
