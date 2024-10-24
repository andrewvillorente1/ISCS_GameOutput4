extends Node2D

var health = 100
var attack_1_damage = 35
var attack_2_damage = 50
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
	match attack_type:
		1:
			play_animation("mage_attack_1")
			return attack_1_damage
		2:
			play_animation("mage_attack_2")
			return attack_2_damage
		_:
			print("Invalid attack type")
			return 0

func defend():
	play_animation("mage_defend")

func heal() -> int:
	play_animation("mage_heal")
	return 20
	
func poison() -> int:
	play_animation("mage_poison")
	return 3 #current amount of damage being dealt * 10

func send_debuff() -> int:
	var random_value = randi() % 100  # Generate a random number between 0 and 99
	if random_value < 80:  # 0 to 79 (80% chance)
		print("YOU MADE ENEMY FALL ASLEEP FOR 2 ROUNDS")
		return 2
	else:  # 80 to 99 (20% chance)
		var oneortwo = randi() % 2 + 1
		print("YOU MADE ENEMY FALL ASLEEP FOR " + str(oneortwo) + " ROUND/S")
		return oneortwo  # Returns either 1 or 2
	
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	print("Mage has been defeated!")
	queue_free()

func play_animation(animation_name: String) -> void:
	is_animating = true
	animated_sprite.play(animation_name)
	await animated_sprite.animation_finished  # Await the end of the animation
	is_animating = false
