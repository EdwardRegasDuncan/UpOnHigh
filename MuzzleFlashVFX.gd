extends GPUParticles3D









func _on_timer_timeout():
	print("killed")
	queue_free()
