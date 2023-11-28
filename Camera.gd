extends Camera3D

@onready var player = get_node("/root/Main/Player")
const FOLLOW_SPEED = 5
const OFFSET = 0.03

const RAYCAST_LENGTH = 1000
const ENVIRONMENT_LAYER_MASK = 1
const MAX_DISTANCE_FROM_PLAYER = 20

const CAMERA_HEIGHT_MIN = 5
const CAMERA_HEIGHT_MAX = 20

@export var pickPosition : Vector3

func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state 
	var mousePos = get_viewport().get_mouse_position()
	
	var origin = project_ray_origin(mousePos)
	var end = origin + project_ray_normal(mousePos) * RAYCAST_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end, 1)
	query.collide_with_areas = true
	
	var result = space_state.intersect_ray(query)
	if !result:
		return
		
	pickPosition = result.position
	
	var cameraOffset = (result.position - player.position) / 3
	
	var target_position = position.lerp(player.position + cameraOffset, FOLLOW_SPEED * delta) 
	position.x = target_position.x
	position.z = target_position.z
	
func _input(event):
	var target_height = position.y
	if Input.is_action_just_released("zoom_in"):
		target_height -= 1
	if Input.is_action_just_released("zoom_out"):
		target_height += 1
	position.y = clamp(target_height, CAMERA_HEIGHT_MIN, CAMERA_HEIGHT_MAX)
