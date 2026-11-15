extends Camera2D

class_name Camera

@export var speed : float = 60
@export var look_ahead : float = 0.07
@export var deadzone : float = 40.0

#var dead_zone_mulit : float
#var dead_zone_target_mulit : float

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (player.death_playing): return;
	
	#dead_zone_target_mulit = 1.0
	#if (global_position.distance_squared_to(player.global_position) > deadzone * deadzone):
		#print ("dead")
		#dead_zone_target_mulit = 0.1
	#
	#dead_zone_mulit = lerp(dead_zone_mulit, dead_zone_target_mulit, 20 * delta)
	
	global_position = lerp(global_position, player.global_position + (player.velocity * look_ahead), speed * delta)
