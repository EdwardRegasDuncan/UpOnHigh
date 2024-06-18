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
var currentshotgunammo
var maxshotgunAmmo = 2
var maxmgAmmo = 30
var ammoTotal
var reloading
@export var firing_vfx: PackedScene
@export var bullet: PackedScene
@export var weapons: Array[PackedScene]

func _ready():
	current_mg_ammo = maxmgAmmo
	currentshotgunammo = maxshotgunAmmo

func _process(delta):
	if Input.is_action_pressed("shoot") and canFire == true:
		_fire()
		print(canFire)

func _fire():
	pass

func _reload():

		if machinegunActive == true:
			ammoCount = maxmgAmmo
			canFire = true

		if shotgunActive == true:
			ammoCount = maxshotgunAmmo

	

func _interact():
	#Check if can be equipped
	#equip
	pass

