extends Node2D

@export var in_team: bool
@export var skill_num: int = 2
@export var speed: int = 2

@export var unit_name = "Archer"
var health = 90

var is_animating = false

var received_status = "none"
var status_count = 0

var crit_chance = 40

@onready var animated_sprite = $AnimatedSprite2D

signal skill_target(skill_type: int)

func _ready() -> void:
	if in_team:
		animated_sprite.scale.x = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_animating:  # Only play idle if no other animation is playing
		animated_sprite.play("idle")
	pass

#Attacks:

# Single attack function with an integer determining the type of attack
func attack() -> int:
	var attack_damage = randi_range(20, 30)

	if randi_range(0, 100) <= crit_chance:
		attack_damage *= 2
	
	if crit_chance > 40:
		crit_chance -= 10
		print("crit lowered by 10%")

	play_animation("archer_attack_1")
	return attack_damage

func enhance_crit():
	play_animation("archer_crit")
	crit_chance = 100
	print('crit enhanced to 80%, lowers 10% each round until 40% base')

func skill_set(skill: int):
	if skill == 0:
		attack()
	else:
		enhance_crit()

func skill_signal(skill: int):
	if skill == 0:
		emit_signal("skill_target", 0)
	else:
		emit_signal("skill_target", 2)

func skill_names(skill: int) -> String:
	if skill == 0:
		return "attack"
	else:
		return "enhance crit"

#damage:
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	print("Warrior has been defeated!")
	queue_free()

#status:

# call when receiving status
func receive_status(status: String):
	if received_status != "none":
		received_status = status
		status_count = 2
	else:
		print("already have status cannot override")

# call at the start of every turn
func effect_status():
	if status_count > 0:
		if received_status == "posion":
			for i in range (10): 
				take_damage(1)
		elif received_status == "sleep":
			print("sleeping")
		status_count -= 1
	else:
		received_status = "none"
	


#healed
#todo: move to mage ability
func add_health(add_health: int) -> void:
	health += add_health

#animation
func play_animation(animation_name: String) -> void:
	is_animating = true
	animated_sprite.play(animation_name)
	await animated_sprite.animation_finished  # Await the end of the animation
	is_animating = false
