extends Node3D

@export var enemy: PackedScene

@onready var spawn_path = $Path3D/SpawnLocation
@onready var interact_distance = $Area3D

var can_interact = true
var activated = false
var min_enemies = 3
var max_enemies = 6

func _on_area_3d_body_entered(body):
	print("Detected Something: " % body.is_in_group("Players"))
	if !body.is_in_group("Players"):
		return
	
	var enemy_count = randi_range(min_enemies, max_enemies)
	for i in range(enemy_count):
		var new_enemy = enemy.instantiate()
		print("Spawned Enemy: " % new_enemy.name)
		spawn_path.progress_ratio = randf()
		var spawn_pos = spawn_path.position
		new_enemy.global_transform = spawn_pos
