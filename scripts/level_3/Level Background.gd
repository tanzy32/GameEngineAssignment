extends TileMap

var water_tile_data = get_cell_tile_data(0, Vector2i.ZERO)
var water_tile
# Called when the node enters the scene tree for the first time.
func _ready():
	water_tile = water_tile_data.get_custom_data("number")
	print(water_tile)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
