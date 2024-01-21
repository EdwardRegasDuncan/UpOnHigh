extends CharacterBody3D

@export var health = 10

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		kill()

func kill():
	queue_free()
