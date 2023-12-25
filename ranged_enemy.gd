extends CharacterBody3D


@onready var shootDelayTimer = $ShootDelayTimer
var player
var speed = 5
var canFire
var fireDelay = 2.0
@export var firing_vfx: PackedScene
@export var bullet: PackedScene
@export var health = 3

func _ready():
	player = $"../Player"

func _physics_process(delta):
	var distance = position.distance_to(player.position)

	velocity = Vector3.ZERO
	
	if distance > 5:
		velocity = position.direction_to(player.position) * speed
		look_at(player.global_transform.origin, Vector3.UP)
	else: 
		canFire = true
		look_at(player.global_transform.origin, Vector3.UP)
	if canFire == true and shootDelayTimer.is_stopped():
		_shoot()
		shootDelayTimer.start(fireDelay)
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
func _on_area_3d_area_entered(area):
	if area.is_in_group("Projectiles"):
		DealDamage()
func DealDamage():
	print("taking damage")
	health -= 1
	if health <= 0:
		kill()
func kill():
	queue_free()








