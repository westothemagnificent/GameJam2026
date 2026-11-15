extends Area2D

@export var rotation_speed : float = 80.0;
@export var deletes : bool = true
@onready var sprite : Sprite2D = $"sprite"

var target_material : ShaderMaterial

var xRot : float = 0.0;
var yRot : float = 0.0;

func _ready() -> void:
	target_material = sprite.material as ShaderMaterial
	
func _process(delta: float) -> void:
	target_material.set_shader_parameter("xDegrees", xRot)
	target_material.set_shader_parameter("yDegrees", yRot)
	
	xRot += rotation_speed * delta
	yRot += rotation_speed * delta * 0.7

func _on_body_entered(body: Node2D) -> void:
	if (!body.is_in_group("player")): return
	
	var player : Player = body as Player
	
	player.flip = !player.flip
	
	if (deletes): queue_free()
