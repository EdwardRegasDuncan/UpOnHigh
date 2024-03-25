class_name Gun_Class
extends Node3D
var firing_interval
var interactible
var magazine_size
var canFire

@export var firing_vfx: PackedScene
@export var bullet: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("shoot"):
		_fire()
func _fire():
	if(canFire == true):
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
		canFire = false
		$FiringTimer.start()
	else:
		return
func _reload():
	#Check if reload possible
	#Reload anim
	#Refill mag
	pass
func _interact():
	#Check if can be equipped
	#equip
	pass


func _on_firing_timer_timeout():
	canFire = true
