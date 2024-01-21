class_name HurtBox3D
extends Area3D

func _init() -> void: # Expl: On object initalise run this anonymous function that returns nothing
	collision_layer = 3
	collision_mask = 3

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(hitbox: HitBox3D) -> void:
	if hitbox == null:
		return
		
	if hitbox.owner == owner:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
