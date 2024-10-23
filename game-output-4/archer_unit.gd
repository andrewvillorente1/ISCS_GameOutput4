extends Node2D

var health = 110
var multiplier_counter = 0
var attack_multiplier = 1
var debuff_turn_counter = 0
var is_animating = false
@onready var animated_sprite = $ArcherSprite2D

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_animating and animated_sprite.animation != "archer_idle":
		animated_sprite.play("archer_idle")


# Single attack function with an integer determining the type of attack
func attack(attack_type: int) -> int:
	multiplier_counter += 1
	var attack_1_damage = 35 * attack_multiplier
	var attack_2_damage = 40 * attack_multiplier
	match attack_type:
		1:
			play_animation("archer_attack_1")
			return attack_1_damage
		2:
			play_animation("archer_attack_2")
			return attack_2_damage
		_:
			print("Invalid attack type")
			return 0

func attack_multiplier_roll():
	var random_value = randi() % 100  # Generate a random number between 0 and 99
	if random_value < 10:  # 0 to 9 (10% chance)
		attack_multiplier = 2
	else:  # 10 to 99 (90% chance)
		attack_multiplier = 1

func return_multiplier_count() -> int:
	return multiplier_counter

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func get_poisoned(amount: int):
	play_animation("archer_poisoned")
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

func die():
	print("Archer has been defeated!")
	queue_free()

func play_animation(animation_name: String) -> void:
	is_animating = true
	animated_sprite.play(animation_name)
	print("Playing animation:", animation_name)
	await animated_sprite.animation_finished  # Await the end of the animation
	print("Animation finished:", animation_name)
	is_animating = false
	animated_sprite.play("archer_idle")
	print("Switched back to idle")
