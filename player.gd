extends CharacterBody3D

const MOVE_SPEED = 500
const shoot_damage = 1

@onready var cam : Camera3D = get_node("/root/Main/Camera")
@onready var gunbarrel = get_node("BIGGUN/GunBarrel")

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
	


	var pickPos = cam.pickPosition
	var targetPos = Vector3(pickPos.x, position.y, pickPos.z)
	
	look_at(targetPos, Vector3.UP)
	DebugDraw3D.draw_sphere(targetPos)
	
	# Shooting
	if Input.is_action_just_pressed("shoot"):
		shoot(targetPos)
	
	move_and_slide()

func shoot(targetPos: Vector3):
	var space_state = get_world_3d().direct_space_state
	var end = position + targetPos * 10000
	end.y = position.y
	var query = PhysicsRayQueryParameters3D.create(position, end, 2)
	DebugDraw3D.draw_line(position, end, Color.BLUE, 50)
	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	if !result:
		return
	
	var target = result.collider
	target.DealDamage(shoot_damage)
	print($"Hit: %s", target if !null else "nothing")






