extends CharacterBody3D

@export var health = 3

func DealDamage(damage:float):
	health -= 1
	if health <= 0:
		kill()

func kill():
	queue_free()
