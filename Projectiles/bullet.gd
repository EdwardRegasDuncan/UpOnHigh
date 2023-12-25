extends CharacterBody3D

@export var bullet_speed = 70

func _physics_process(delta):
	var forward_direction = global_transform.basis.z.normalized()
	move_and_collide(forward_direction * bullet_speed * delta)

func _on_area_3d_area_entered(area):
	var damage = 1
#	if area.is_in_group("Players"):
#		area.DealDamage(damage)
#		print("hit player")
#	elif area.is_in_group("Enemies"):
#		print("hit enemy")
#		area.DealDamage(damage)
	queue_free()

func _on_timer_timeout():
	
	queue_free()
	
