extends Node

class_name Main

@export var levels : Array[String]
@export var current_level : int = 0

@onready var player : Player = $"player"
@onready var camera : Camera = $"cam"

@onready var forwards_bg : AudioStreamPlayer = $"forwards"

var level_node : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.player = player
	player.main = self
	
	load_level()


func _on_win_body_entered(body: Node2D) -> void:
	if (!body.is_in_group("player")): return
	
	current_level += 1
	
	if (current_level + 1 > levels.size()):
		return
	
	load_level.call_deferred()

func load_level():
	if (level_node != null): level_node.free()
	
	var new_level_node : Node2D = (load(levels[current_level]) as PackedScene).instantiate()
	
	add_child(new_level_node)
	
	level_node = new_level_node
	
	player.tilemap = new_level_node.get_node("level")
	
	player.flip = false
	player.velocity = Vector2.ZERO
	player.global_position = $"spawn".global_position
	
	print("level loaded")
