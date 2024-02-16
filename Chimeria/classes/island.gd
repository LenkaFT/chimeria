class_name Island

var size : int;
var age_class : String;
var size_class : String;
var starting_tile : Tile;
var type : String;
var tiles_array : Array[Tile];
var tile_weights : Dictionary;
var size_weights : Dictionary = {
	"small" : 50,
	"medium" : 35,
	"large" : 10,
	"very_large" : 5
	}
var age_weights : Dictionary = {
	"recent" : 25,
	"medium" : 50,
	"old" : 25,
	"total" : 100
	}

func _init(tile : Tile, island_max_size : int) :
	randomize();
	
	size_class = random_with_weights(size_weights);
	if size_class == "small" : 
		size = RandomNumberGenerator.new().randi_range(1, island_max_size / 4);
	if size_class == "medium" : 
		size = RandomNumberGenerator.new().randi_range(island_max_size / 4, island_max_size / 2);
	if size_class == "large" : 
		size = RandomNumberGenerator.new().randi_range(island_max_size / 2, island_max_size / 2 + island_max_size / 4)
	if size_class == "very_large" : 
		size = island_max_size;
	starting_tile = tile;
	age_class = random_with_weights(age_weights)
	init_temperate_weights();
	tiles_array.append(tile);

func random_with_weights(weights : Dictionary):
	randomize();
	var rand = RandomNumberGenerator.new().randi_range(1, 100);
	var cursor = 0;
	var type : String;
	for key in weights :
		if key == "total" :
			break;
		cursor += weights[key];
		if cursor >= rand :
			type = key;
			print("TYPE = ", type)
			return (type);
			
func is_able_to_expand(grid : Array, available_tiles : Array[Tile]) :
	for n in tiles_array.size() :
		if (tiles_array[n].getNorthTile(grid) && available_tiles.find(tiles_array[n].getNorthTile(grid)) ||
		tiles_array[n].getSouthTile(grid) && available_tiles.find(tiles_array[n].getSouthTile(grid)) ||
		tiles_array[n].getEastTile(grid) && available_tiles.find(tiles_array[n].getEastTile(grid)) ||
		tiles_array[n].getWestTile(grid) && available_tiles.find(tiles_array[n].getWestTile(grid))) :
			return (true);
	return (false);

func expand_island(grid : Array, available_tiles : Array[Tile], map : Map) :
	var placed_tiles = 0;
	var new_tile;
	var origin : Tile = grid[starting_tile.y][starting_tile.x];
	
	while is_able_to_expand(grid, available_tiles) && placed_tiles <= self.size :
		while 1 :
			var direction = GV.direction_array[RandomNumberGenerator.new().randi() % 4];
			if direction == "North" :
				new_tile = origin.getNorthTile(grid);
			if direction == "South" :
				new_tile = origin.getSouthTile(grid);
			if direction == "West" :
				new_tile = origin.getWestTile(grid)
			if direction == "East" :
				new_tile = origin.getEastTile(grid)
			
			## random method
			if new_tile == null :
				origin = self.tiles_array[RandomNumberGenerator.new().randi_range(0, self.tiles_array.size() - 1)];
				break ;
			elif placed_tiles > size :
				break;
			
			else :
				new_tile = map.create_tile_instance(random_with_weights(tile_weights) ,new_tile.x, new_tile.y, new_tile.id, -1);
				map.replace_tile(new_tile.x, new_tile.y, new_tile);
				self.tiles_array.append(new_tile);
				placed_tiles += 1;
			origin = new_tile;

func init_temperate_weights() :
	if age_class == "recent" :
		tile_weights = {
			GV.shallow_watters : (10),
			GV.prairie : 10,
			GV.forest : (40),
			GV.desert : (0),
			GV.mountain : (40),
			"total" : 100
		}
	if age_class == "medium" :
		tile_weights = {
			GV.shallow_watters : (10),
			GV.prairie : 30,
			GV.forest : (40),
			GV.desert : (0),
			GV.mountain : (20),
			"total" : 100
		}
	if age_class == "old" :
		tile_weights = {
			GV.shallow_watters : (20),
			GV.prairie : 40,
			GV.forest : (30),
			GV.desert : (0),
			GV.mountain : (10),
			"total" : 100
		}
	
