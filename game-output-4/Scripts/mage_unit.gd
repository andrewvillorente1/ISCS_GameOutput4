extends Node2D

var unit_name = "Mage"
var health = 100

var is_animating = false

var received_status = "none"
var status_count = 0

@onready var animated_sprite = $AnimatedSprite2D


func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_animating:  # Only play idle if no other animation is playing
		animated_sprite.play("idle")


#Attacks: Mage does not attack, it can only heal, poion, or make enemy fall asleep

# Single attack function with an integer determining the type of attack
func sleep() -> String:
	play_animation("mage_sleep")
	if randi_range(0, 100) <= 50:
		return "sleep"
	else:
		print("landing sleep failed (50/50)")
		return ""

func posion() -> String:
	play_animation("mage_poison")
	if randi_range(0, 100) <= 80:
		return "posion"
	else:
		print("landing posion failed (80/20)")
		return ""

#change it so that it calls the "add health function of the class"
func heal() -> int:
	play_animation("mage_heal")
	return 10

#damage:
func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	print("Tank has been defeated!")
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
	

func add_health(add_health: int) -> void:
	health += add_health

#animation
func play_animation(animation_name: String) -> void:
	is_animating = true
	animated_sprite.play(animation_name)
	await animated_sprite.animation_finished  # Await the end of the animation
	is_animating = false
