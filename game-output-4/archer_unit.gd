extends Node2D

var health = 110
var attack_1_damage = 30
var attack_2_damage = 45
var attack_3_damage = 65

# Animations
@onready var animated_sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animated_sprite.play("idle")

# Single attack function with an integer determining the type of attack
func attack(attack_type: int) -> int:
	match attack_type:
		1:
			animated_sprite.play("archer_attack_1")
			return attack_1_damage
		2:
			animated_sprite.play("archer_attack_2")
			return attack_2_damage
		3:
			animated_sprite.play("archer_attack_3")
			return attack_3_damage
		_:
			print("Invalid attack type")
			return 0

func defend_1():
	animated_sprite.play("archer_defend_1")

func defend_2():
	animated_sprite.play("archer_defend_2")

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	print("Archer has been defeated!")
	queue_free()
