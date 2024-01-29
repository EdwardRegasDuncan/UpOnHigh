extends CharacterBody3D

@export var PlayerTarget: Node3D

@onready var shootDelayTimer = $ShootDelayTimer
@onready var shootPauseTimer = $ShootPauseTimer
@onready var hit_stun_timer = $HitStunTimer
@onready var hit_stun_animation = $HitStunAnimation

var player
var speed = 50
var canFire
var hit = false
const fire_range = 5
const engagement_range = 10

@export var firing_vfx: PackedScene
@export var bullet: PackedScene
@export var health = 100
@export var enable_health = false
@export var enable_movement = false
@export var enable_shooting = false

func _ready():
	player = $"../Player"

func _physics_process(delta):
	
	if hit:
		return
	
	var distance = position.distance_to(player.position)

	velocity = Vector3.ZERO
	
	if distance > fire_range and distance < engagement_range:
		# TODO: 15/01/24 Replace with NavigationServer3D
		if enable_movement:
			velocity = position.direction_to(player.position) * speed * delta
		look_at(player.global_transform.origin, Vector3.UP)
		canFire = false
	elif distance < fire_range: 
		canFire = true
		look_at(player.global_transform.origin, Vector3.UP)
	if canFire == true and shootDelayTimer.is_stopped():
		_shoot()
		shootDelayTimer.start()
		canFire = false
	
	move_and_slide()

func _shoot():
	if !enable_shooting:
		return
	var firing_effect_instance : GPUParticles3D = firing_vfx.instantiate()
	firing_effect_instance.global_transform = $Gun/GunBarrel.global_transform
	firing_effect_instance.scale = Vector3(1, 1, 1)
	firing_effect_instance.emitting = true
	var new_bullet = bullet.instantiate()
	new_bullet.global_transform = $Gun/GunBarrel.global_transform
	new_bullet.scale = Vector3(1, 1, 1)
	var scene_root = get_tree().get_root().get_children()[0] #fetches first node of the loaded scene tree 
	scene_root.add_child(new_bullet)
	scene_root.add_child(firing_effect_instance)
	
func hitStun():
	hit = true
	if hit_stun_animation.is_playing():
		hit_stun_animation.stop()
	hit_stun_animation.play("HitStun_1")
	hit_stun_timer.start()
	await hit_stun_timer.timeout
	hit = false

func take_damage(amount: int) -> void:
	print("taking damage")
	if enable_health:
		health -= amount
	if health <= 0:
		kill()
	hitStun()
		
func kill():
	queue_free()








