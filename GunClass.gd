class_name Gun_Class
extends Node3D
var firing_interval
var interactible
var magazine_size
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _fire():
	if(Input.is_action_pressed("shoot")):
		#Check direction
		#Spawn projectile
		#Kill projectile after hit or timeout #move stuff to parent class
		pass
func _reload():
	#Check if reload possible
	#Reload anim
	#Refill mag
	pass
func _interact():
	#Check if can be equipped
	#equip
	pass
