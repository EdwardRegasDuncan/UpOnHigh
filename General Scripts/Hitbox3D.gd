class_name HitBox3D
extends Area3D

@export var damage := 10

func _init() -> void:
	collision_layer = 2
	collision_mask = 2