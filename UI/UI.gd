extends Control
var player 

@onready var ammo_label = $AmmoLabel

func _ready():
	player = get_node("/root/Main/Player")

func _process(delta):
	if player != null and player.currentWeaponInstance != null:
		var ammo_count = player.currentWeaponInstance.ammoCount
		ammo_label.text = "Ammo: " + str(ammo_count)
	else:
		ammo_label.text = "Ammo: -" 
