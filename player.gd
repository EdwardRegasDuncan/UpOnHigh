extends CharacterBody3D
@export var bullet: PackedScene
@export var firing_vfx: PackedScene

const MOVE_SPEED = 500
const shoot_damage = 1

@onready var cam : Camera3D = get_node("/root/Main/Camera")
@onready var gunbarrel = get_node("BIGGUN/GunBarrel")

var bullet_speed = 30
var firerate_per_ms


func _physics_process(delta):
	
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	direction = direction.normalized();
	velocity = direction * MOVE_SPEED * delta
	move_and_slide()


	var pickPos = cam.pickPosition
	var targetPos = Vector3(pickPos.x, position.y, pickPos.z)
	targetPos.y = position.y
	
	look_at(targetPos, Vector3.UP)
	DebugDraw3D.draw_sphere(targetPos)

	# Shooting
	if Input.is_action_just_pressed("shoot"):
#		shoot(targetPos)
		shoot()

	
	

#func shoot(targetPos: Vector3):
#	var space_state = get_world_3d().direct_space_state
#	var end = targetPos * 10000
#	end.y = position.y
#	var query = PhysicsRayQueryParameters3D.create(position, end)
#	DebugDraw3D.draw_line(position, end, Color.BLUE, 50)
#	query.collide_with_areas = true
#
#	var result = space_state.intersect_ray(query)
#	if !result:
#		return
#
#	var target = result.collider
#	target.DealDamage(shoot_damage)
#	print($"Hit: %s", target if !null else "nothing")
#
func shoot():
	var firing_effect_instance : GPUParticles3D = firing_vfx.instantiate()
	firing_effect_instance.global_transform = $BIGGUN/GunBarrel.global_transform
	
	firing_effect_instance.scale = Vector3(1, 1, 1)
	
	firing_effect_instance.emitting = true
	
	
	var new_bullet = bullet.instantiate()
	new_bullet.global_transform = $BIGGUN/GunBarrel.global_transform
	new_bullet.scale = Vector3(1, 1, 1)
#	new_bullet.speed = firerate_per_ms
	var scene_root = get_tree().get_root().get_children()[0] #fetches first node of the loaded scene tree 
	scene_root.add_child(new_bullet)
	scene_root.add_child(firing_effect_instance)
	






