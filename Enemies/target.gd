extends CharacterBody3D

@export var health = 10
@export var enable_health = false

@onready var hit_stun_animation = $HitStunAnimation

func take_damage(amount: int) -> void:
	if hit_stun_animation.is_playing():
		hit_stun_animation.stop()
	hit_stun_animation.play("HitStun_1")
	if !enable_health:
		return
	health -= amount
	if health <= 0:
		kill()

func kill():
	queue_free()
