extends Node2D

var health = 250
var attack_1_damage = 20 
var attack_2_damage = 25 
var attack_3_damage = 30 
var debuff_turn_counter = 0
var is_animating = false
  
# Animations
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
			play_animation("tank_attack_1")
			return attack_1_damage  # You can apply the damage after the animation is done
		2:
			play_animation("tank_attack_2")
			return attack_2_damage
		3:
			play_animation("tank_attack_3")
			return attack_3_damage
		_:
			print("Invalid attack type")
			return 0

func defend():
	play_animation("tank_defend")

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func damage_heal(add_health: int) -> void:
	health += add_health

func die():
	print("Warrior has been defeated!")
	queue_free()

func play_animation(animation_name: String) -> void:
	is_animating = true
	animated_sprite.play(animation_name)
	await animated_sprite.animation_finished  # Await the end of the animation
	is_animating = false
