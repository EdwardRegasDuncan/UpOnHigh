extends CharacterBody3D

@export var bullet_speed = 70

func _physics_process(delta):
	var forward_direction = global_transform.basis.z.normalized()
	move_and_collide(forward_direction * bullet_speed * delta)

func _on_area_3d_area_entered(area):
	
	queue_free()

func _on_timer_timeout():
	
	queue_free()
	
