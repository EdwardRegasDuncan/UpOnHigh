extends Gun_Class

func _ready():
	shotgunActive = true
	ammoCount = GunClass.currentshotgunammo
	if ammoCount == 0:
		$ReloadTimer.start()
		$AnimationPlayer.play("Reload")
	if ammoCount > 0:
		canFire = true
		print(ammoCount)

func _physics_process(delta):
	if ammoCount > 0:
		canFire = true

func _input(event):
	if event.is_action_pressed("reload"):
		$ReloadTimer.start()
		$AnimationPlayer.play("Reload")
	if event.is_action_pressed("shoot"):
		_fire()
func _fire():
	if shotgunActive == true and canFire == true and $FiringTimer.is_stopped():
		print("firing")
		$AnimationPlayer.play("Recoil")
		var firing_effect_instance : GPUParticles3D = firing_vfx.instantiate()
		firing_effect_instance.global_transform = $MeshInstance3D/Gun_Barrel1.global_transform
		firing_effect_instance.scale = Vector3(1, 1, 1)
		firing_effect_instance.emitting = true
		var new_bullet1 = bullet.instantiate()
		new_bullet1.global_transform = $MeshInstance3D/Gun_Barrel1.global_transform
		var new_bullet2 = bullet.instantiate()
		new_bullet2.global_transform = $MeshInstance3D/Gun_Barrel2.global_transform
		var new_bullet3 = bullet.instantiate()
		new_bullet3.global_transform = $MeshInstance3D/Gun_Barrel3.global_transform
		new_bullet3.scale = Vector3(1, 1, 1)
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_bullet1)
		scene_root.add_child(new_bullet2)
		scene_root.add_child(new_bullet3)
		scene_root.add_child(firing_effect_instance)
#		canFire = false
		ammoCount -= 1
		GunClass.currentshotgunammo = ammoCount
		$FiringTimer.start()
		#firing twice - fix
		if ammoCount == 0:
			$ReloadTimer.start()
			$AnimationPlayer.play("Reload")
	else:
		print("cannot fire")

func _on_reload_timer_timeout():
	_reload()
