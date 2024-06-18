extends CharacterBody3D
@export var bullet: PackedScene
@export var firing_vfx: PackedScene
@export var health = 50
@export var enable_health = true
@export var machinegun: PackedScene
@export var shotgun: PackedScene
@export var lasergun: PackedScene
@export var UI: PackedScene
@export var DataHandler: PackedScene
const MOVE_SPEED = 500
const attacking_move_penalty = 0.4
const shoot_damage = 1

@onready var cam : Camera3D = get_node("/root/Main/Camera")
@onready var gunbarrel = get_node("BIGGUN/GunBarrel")
@onready var attack_animation_1 = $Attack1
@onready var attack_cooldown = $AttackTimer
@onready var combo_timer = $ComboTimer
var weapon1
var weapon2
var currentWeaponInstance 
var currentWeapon : int = 1
var bullet_speed = 30
var current_mg_Ammo
var is_attacking = false
var combo_count = 0
const combo_duration = 1


func _ready():
	var ui_instance = UI.instantiate()
	$".".add_child(ui_instance)
	_equipWeapon(1)

func _equipWeapon(weaponIndex):
	match weaponIndex:
		1:
			if currentWeaponInstance != null:
				currentWeaponInstance.queue_free()
			var new_machinegun = machinegun.instantiate()
			new_machinegun.scale = Vector3(1, 1, 1)
			$GunSocket.add_child(new_machinegun) #adds as child of player
			currentWeaponInstance = new_machinegun

		2:

			if currentWeaponInstance != null:
				currentWeaponInstance.queue_free()
			var new_shotgun = shotgun.instantiate()
			new_shotgun.scale = Vector3(1, 1, 1)
			$GunSocket.add_child(new_shotgun)
			currentWeaponInstance = new_shotgun
#		3:
#			if currentWeaponInstance != null:
#				currentWeaponInstance.queue_free()
#			var new_lasergun = lasergun.instantiate()
#			new_lasergun.global_transform = $GunSocket.global_transform
#			new_lasergun.scale = Vector3(1, 1, 1)
#			$".".add_child(new_lasergun)
#			currentWeaponInstance = new_lasergun
func _input(event):
	if Input.is_action_just_pressed("equip_weapon1"):
		_equipWeapon(1)
	elif Input.is_action_just_pressed("equip_weapon2"):
		_equipWeapon(2)
	elif Input.is_action_just_pressed("equip_weapon3"):
		_equipWeapon(3)
	if Input.is_action_just_pressed("alt_fire"):
		meleeAttack()
	if Input.is_action_just_pressed("interact"):
		return

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
	
	
	var pickPos = cam.pickPosition
	var targetPos = Vector3(pickPos.x, position.y, pickPos.z)
	targetPos.y = position.y
	
	look_at(targetPos, Vector3.UP)
	DebugDraw3D.draw_sphere(targetPos)
	
	if combo_timer.is_stopped():
		combo_count = 0

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
	
func _on_area_3d_area_entered(area):
	print(area.get_groups())
	if area.is_in_group("Ammo") and currentWeaponInstance != null:
		print("found ammo")
		currentWeaponInstance._reload()
	else:
		return
