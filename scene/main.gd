extends Node

@onready var tilemap : TileMapLayer = $"level/level"
@onready var player : Player = $"player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.tilemap = tilemap


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
