extends CharacterBody3D

@export var PlayerTarget: Node3D

var player
var speed = 5


func _ready():
	player = $"../Player"



func _physics_process(delta):
	velocity = Vector3.ZERO
	if player:
		velocity = position.direction_to(player.position) * speed
		look_at(player.global_transform.origin, Vector3.UP)
	move_and_slide()




