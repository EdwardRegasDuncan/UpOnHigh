extends CharacterBody3D
@export var bullet: PackedScene
@export var firing_vfx: PackedScene
@export var health = 50
@export var enable_health = true
const MOVE_SPEED = 500
const attacking_move_penalty = 0.4
const shoot_damage = 1

@onready var cam : Camera3D = get_node("/root/Main/Camera")
@onready var gunbarrel = get_node("BIGGUN/GunBarrel")
@onready var attack_animation_1 = $Attack1
@onready var attack_cooldown = $AttackTimer
@onready var combo_timer = $ComboTimer
var weapon1: Node
var weapon2: Node
var weapon3: Node
var currentWeapon : int = 1
var bullet_speed = 30
var is_attacking = false
var combo_count = 0
const combo_duration = 1



func _ready():
	weapon1 = $MachineGun
	weapon2 = $Shotgun
	weapon3 = $Laser_Gun
	_equipWeapon(1)

func _equipWeapon(weaponIndex):
	weapon1.set_visible(false)
	weapon2.set_visible(false)
	weapon3.set_visible(false)
	
	match weaponIndex:
		1:
			weapon1.set_visible(true)
			currentWeapon = 1
		2:
			weapon2.set_visible(true)
			currentWeapon = 2
		3:
			weapon3.set_visible(true)
			currentWeapon = 3

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
	
	
	velocity = direction * MOVE_SPEED * delta if !is_attacking else direction * (MOVE_SPEED * attacking_move_penalty) * delta
	move_and_slide()
	
	if Input.is_action_just_pressed("equip_weapon1"):
		_equipWeapon(1)
	elif Input.is_action_just_pressed("equip_weapon2"):
		_equipWeapon(2)
	elif Input.is_action_just_pressed("equip_weapon3"):
		_equipWeapon(3)


	var pickPos = cam.pickPosition
	var targetPos = Vector3(pickPos.x, position.y, pickPos.z)
	targetPos.y = position.y
	
	look_at(targetPos, Vector3.UP)
	DebugDraw3D.draw_sphere(targetPos)
	
	if combo_timer.is_stopped():
		combo_count = 0
	
	# Shooting
#	if Input.is_action_just_pressed("shoot"):
#		shoot()
	if Input.is_action_just_pressed("alt_fire"):
		meleeAttack()
	if Input.is_action_just_pressed("interact"):
		return

#func shoot():
#	if is_attacking: 
#		return
#	var firing_effect_instance : GPUParticles3D = firing_vfx.instantiate()
#	firing_effect_instance.global_transform = $BIGGUN/GunBarrel.global_transform
#	firing_effect_instance.scale = Vector3(1, 1, 1)
#	firing_effect_instance.emitting = true
#	var new_bullet = bullet.instantiate()
#	new_bullet.global_transform = $BIGGUN/GunBarrel.global_transform
#	new_bullet.scale = Vector3(1, 1, 1)
#	var scene_root = get_tree().get_root().get_children()[0] #fetches first node of the loaded scene tree 
#	scene_root.add_child(new_bullet)
#	scene_root.add_child(firing_effect_instance)

func meleeAttack():
	if !attack_cooldown.is_stopped():
		return
	combo_timer.start()
	attack_cooldown.start()
		
	combo_count += 1
	is_attacking = true
	var target_anim = 'RESET'
		
	if combo_count == 1:
		target_anim = 'slash_1'
	elif combo_count == 2:
		target_anim = 'slash_2'
	elif combo_count == 3:
		target_anim = 'slash_3'
	else:
		combo_count = 0
		is_attacking = false
		return
		
	attack_animation_1.play(target_anim)
	await get_tree().create_timer(attack_animation_1.current_animation_length).timeout
	is_attacking = false
	attack_animation_1.play("RESET")
		
	
func take_damage(amount: int):
	print("taking damage")
	if !enable_health:
		return
	health -= amount
	if health <= 0:
		kill()

func kill():
	get_tree().quit()
