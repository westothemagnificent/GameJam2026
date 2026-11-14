extends CharacterBody2D

@export var jump_velocity : float = 450.0;
@export var movement_speed : float = 980.0
@export var slow_movement_speed : float = 16.0
@export var acceleration : float = 0.9

var has_double_jump : bool = false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	var slow : bool = Input.is_action_pressed("slow")
	var jump : bool = Input.is_action_just_pressed("jump")
	var onFloor : bool = is_on_floor()
	var onWall : bool = is_on_wall()
	
	if onFloor:
		has_double_jump = true
	
	if (jump && onFloor):
		velocity.y -= jump_velocity
	
	if (jump && has_double_jump && !onFloor):
		velocity.y -= jump_velocity * 1.4
		has_double_jump = false
	
	if !onFloor:
		velocity += get_gravity() * delta
	
	if !onWall:
		velocity.x = lerpf(velocity.x, slow_movement_speed if slow else movement_speed, acceleration * delta)
	
	move_and_slide()
