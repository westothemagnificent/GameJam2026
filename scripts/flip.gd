extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if (!body.is_in_group("player")): return
	
	var player : Player = body as Player
	
	player.flip = true
	
	queue_free()
