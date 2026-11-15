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
var main : Main

var death_playing : bool
var dead : bool
var death_time_till_restart : float = 0.7

@onready var anim : AnimationPlayer = $"anim"
@onready var sprite : Sprite2D = $"sprite"
@onready var jump_part : GPUParticles2D = $"jump"

var tile_transforms : Dictionary = {
	[0]: Vector2(0, -1),
	[TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_TRANSPOSE]: Vector2(1, 0),
	[TileSetAtlasSource.TRANSFORM_FLIP_V | TileSetAtlasSource.TRANSFORM_FLIP_H]: Vector2(0, 1),
	[TileSetAtlasSource.TRANSFORM_FLIP_V | TileSetAtlasSource.TRANSFORM_TRANSPOSE]: Vector2(-1, 0)
}

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if (dead):
		dead = false
		death_playing = true
		
		collision_layer = 0
		collision_mask = 0
		velocity.y = -400
		var sign : float = -1.0 if flip else 1.0
		velocity.x = -sign * 100
		anim.play("jump")

	
	if (death_playing):
		death_time_till_restart -= delta
		death_time_till_restart = clampf(death_time_till_restart, 0.0, INF)
		if (death_time_till_restart <= 0.0):
			main.load_level()
			collision_layer = 1 << 0
			collision_mask = 1 << 0
			death_playing = false
			dead = false
			death_time_till_restart = 0.7
			return
		
		velocity += get_gravity() * delta
		move_and_slide()
		return
	
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
		anim.play("jump")
	
	if (jumpInput && has_double_jump && !onFloor):
		velocity.y = -jump_velocity * 0.8
		has_double_jump = false
		jumpTimer = 0.0
		anim.play("jump")
		jump_part.emitting = true
	
	if !onFloor:
		velocity += get_gravity() * delta
	
	if !onWall:
		var sign : float = -1.0 if flip else 1.0
		velocity.x = sign * lerpf(sign * velocity.x, slow_movement_speed if slowInput else movement_speed, acceleration * delta)
	
	if (!anim.is_playing()):
		anim.play("run")
	
	sprite.flip_h = flip
	
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision : KinematicCollision2D = get_slide_collision(i)
		var tile : Vector2i = tilemap.local_to_map(collision.get_position() - collision.get_normal())
		
		var data : TileData = tilemap.get_cell_tile_data(tile)
		
		if (data == null): 
			push_warning("warn tile has no data")
			continue
		
		var kill : bool = data.get_custom_data("kill") as bool
		var jumpPad : bool = data.get_custom_data("jumpPad") as bool
		
		if (kill): dead = true
		if (jumpPad): 
			var strength : float = data.get_custom_data("strength") as float
			velocity.y = -strength
