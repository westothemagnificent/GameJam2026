@tool

extends TileMapLayer

@export_tool_button("generate") var generate_tool_button : Callable = generate;

@export var cave_length : float = 864.0
@export var height_muiltplier : float = 10.0
@export var cave_height : float = 120.0
@export var noise_texture : NoiseTexture2D

@export var ground_0_tile : Vector2i
@export var ground_1_tile : Vector2i

func generate():
	var noise_texture_image : Image = noise_texture.get_image();
	var noise_texture_width : int = noise_texture.get_width()
	
	
	for tile : Vector2i in get_used_cells():
		var data : TileData = get_cell_tile_data(tile)
		var wasGenerated = data.get_custom_data("generated") as bool;
		
		if (wasGenerated):
			set_cell(tile, -1, Vector2i(), -1)
	
	for i : int in range(cave_length):
		var pixel : int = wrapi(i, 0, noise_texture_width);
		
		var noise_strength : float = noise_texture_image.get_pixel(pixel, 0).r * height_muiltplier;
		var height : float = noise_strength;
		
		for j : int in range(height):
			height -= 1
			
			var tile : Vector2i = Vector2i(i, height);
			
			set_cell(tile, 0, ground_0_tile, 0)
			var data : TileData = get_cell_tile_data(tile)
			data.set_custom_data("generated", true)
			
			var tile2 : Vector2i = Vector2i(i, -height + cave_height);
			
			set_cell(tile2, 0, ground_1_tile, 0)
			var data2 : TileData = get_cell_tile_data(tile2)
			data2.set_custom_data("generated", true)
