extends CharacterBody2D

class_name Player

@export var jump_velocity : float = 350.0;
@export var movement_speed : float = 350.0
@export var slow_movement_speed : float = 64.0
@export var acceleration : float = 0.9

var has_double_jump : bool

var onFloorLastFrame : bool
var flip : bool

var jumpTimer : float

var tilemap : TileMapLayer

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	var slowInput : bool = Input.is_action_pressed("slow")
	var jumpInput : bool = Input.is_action_just_pressed("jump")
	
	var onFloor : bool = is_on_floor()
	var onWall : bool = is_on_wall()
	
	jumpTimer -= delta
	jumpTimer = clampf(jumpTimer, 0.0, INF)
	
	if jumpInput && !onFloor:
		jumpTimer = 0.12
		
	var jumpReady : bool = jumpInput || jumpTimer > 0.0
	
	if onFloor:
		has_double_jump = true
		jumpTimer = 0.0
	
	if (jumpReady && onFloor):
		velocity.y = -jump_velocity
		jumpTimer = 0.0
	
	if (jumpInput && has_double_jump && !onFloor):
		velocity.y = -jump_velocity * 0.8
		has_double_jump = false
		jumpTimer = 0.0
	
	if !onFloor:
		velocity += get_gravity() * delta
	
	if !onWall:
		var sign : float = -1.0 if flip else 1.0
		velocity.x = sign * lerpf(sign * velocity.x, slow_movement_speed if slowInput else movement_speed, acceleration * delta)
	
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision : KinematicCollision2D = get_slide_collision(i)
		var tile : Vector2i = tilemap.local_to_map(collision.get_position() - collision.get_normal())
		
		var data : TileData = tilemap.get_cell_tile_data(tile)
		var kill = data.get_custom_data("kill") as bool
		
		if (kill): get_tree().reload_current_scene.call_deferred()
