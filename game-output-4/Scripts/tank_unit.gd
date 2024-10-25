extends Node2D

var unit_name = "Tank"
var health = 180

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


#Attacks:

# Single attack function with an integer determining the type of attack
func attack() -> int:
	var attack_damage = randi_range(20, 25)
	play_animation("tank_attack_1")
	return attack_damage  # You can apply the damage after the animation is done

func defend():
	play_animation("tank_defend")



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
