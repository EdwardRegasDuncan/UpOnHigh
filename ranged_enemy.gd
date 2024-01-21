extends CharacterBody3D

@export var PlayerTarget: Node3D
@export var enabled = false

@onready var shootDelayTimer = $ShootDelayTimer
@onready var shootPauseTimer = $ShootPauseTimer
var player
var speed = 50
var canFire
const fire_range = 5
@export var firing_vfx: PackedScene
@export var bullet: PackedScene
@export var health = 30

func _ready():
	player = $"../Player"

func _physics_process(delta):
	if !enabled:
		return
	
	var distance = position.distance_to(player.position)

	velocity = Vector3.ZERO
	
	if distance > fire_range:
		# TODO: 15/01/24 Replace with NavigationServer3D
		velocity = position.direction_to(player.position) * speed * delta
		look_at(player.global_transform.origin, Vector3.UP)
		canFire = false
	else: 
		canFire = true
		look_at(player.global_transform.origin, Vector3.UP)
	if canFire == true and shootDelayTimer.is_stopped():
		_shoot()
		shootDelayTimer.start()
		canFire = false
		
	move_and_slide()

func _shoot():
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

func take_damage(amount: int) -> void:
	print("taking damage")
	health -= amount
	if health <= 0:
		kill()
		
func kill():
	queue_free()








