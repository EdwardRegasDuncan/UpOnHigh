extends CharacterBody3D
@export var bullet: PackedScene
@export var firing_vfx: PackedScene
@export var health = 50
const MOVE_SPEED = 500
const shoot_damage = 1

@onready var cam : Camera3D = get_node("/root/Main/Camera")
@onready var gunbarrel = get_node("BIGGUN/GunBarrel")
@onready var hitBoxes = [get_node("Melee1"), get_node("Melee2"), get_node("Melee3")]
@onready var attack_animation_1 = $Attack1

var bullet_speed = 30
var is_attacking = false
var comboCount = 0
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
	
	if !is_attacking:
		velocity = direction * MOVE_SPEED * delta
		
	move_and_slide()


	var pickPos = cam.pickPosition
	var targetPos = Vector3(pickPos.x, position.y, pickPos.z)
	targetPos.y = position.y
	
	look_at(targetPos, Vector3.UP)
	DebugDraw3D.draw_sphere(targetPos)
	
	# Shooting
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("alt_fire"):
		meleeAttack()

func shoot():
	if is_attacking: 
		return
	var firing_effect_instance : GPUParticles3D = firing_vfx.instantiate()
	firing_effect_instance.global_transform = $BIGGUN/GunBarrel.global_transform
	firing_effect_instance.scale = Vector3(1, 1, 1)
	firing_effect_instance.emitting = true
	var new_bullet = bullet.instantiate()
	new_bullet.global_transform = $BIGGUN/GunBarrel.global_transform
	new_bullet.scale = Vector3(1, 1, 1)
	var scene_root = get_tree().get_root().get_children()[0] #fetches first node of the loaded scene tree 
	scene_root.add_child(new_bullet)
	scene_root.add_child(firing_effect_instance)

func meleeAttack():
	comboCount += 1
	is_attacking = true
	attack_animation_1.play("Slash_1")
	await get_tree().create_timer(attack_animation_1.current_animation_length).timeout
	is_attacking = false
	attack_animation_1.play("RESET")
	
func take_damage(amount: int):
	print("taking damage")
	health -= amount
	if health <= 0:
		kill()

func kill():
	get_tree().quit()
