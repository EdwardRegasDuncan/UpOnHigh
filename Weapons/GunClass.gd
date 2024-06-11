class_name Gun_Class
extends Node3D
var firing_interval
var interactible
var magazine_size
var canFire
var machinegunActive
var shotgunActive
var lasergunActive
var ammoCount
var current_mg_ammo
var maxAmmo
var ammoTotal
@export var firing_vfx: PackedScene
@export var bullet: PackedScene
@export var weapons: Array[PackedScene]

func _ready():
	current_mg_ammo = 30

func _process(delta):
	if Input.is_action_pressed("shoot"):
		_fire()

func _fire():
	pass

func _reload():
	ammoCount = maxAmmo

func _interact():
	#Check if can be equipped
	#equip
	pass

func _on_firing_timer_timeout():
	canFire = true
