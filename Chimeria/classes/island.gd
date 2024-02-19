class_name Island

var size : int;
var age_class : String;
var size_class : String;
var starting_tile : Tile;
var type : String;
var tiles_array : Array[Tile];
var tile_weights : Dictionary;
var size_weights : Dictionary = {
	"very_small" : 30,	
	"small" : 30,
	"medium" : 25,
	"large" : 10,
	"very_large" : 5,
	"total" : 100	
	}
var age_weights : Dictionary = {
	"recent" : 25,
	"medium" : 50,
	"old" : 25,
	"total" : 100
	}

func _init(tile : Tile, island_max_size : int, map : Map) :
	randomize();
	
	size_class = random_with_weights(size_weights);
	if size_class == "very_small" : 
		size = 1;
	elif size_class == "small" : 
		size = RandomNumberGenerator.new().randi_range(1, island_max_size / 4);
	elif size_class == "medium" : 
		size = RandomNumberGenerator.new().randi_range(island_max_size / 4, island_max_size / 2);
	elif size_class == "large" : 
		size = RandomNumberGenerator.new().randi_range(island_max_size / 2, island_max_size / 2 + island_max_size / 4)
	elif size_class == "very_large" : 
		size = island_max_size;
	starting_tile = tile;
	age_class = random_with_weights(age_weights)
	
	if tile.y < map.polar_circle || tile.y > map.grid_height - map.polar_circle:
		init_arctic_weights();
	elif tile.y > map.north_tropic && tile.y < map.south_tropic :
		init_tropical_weights()
	else :
		var rand = RandomNumberGenerator.new().randi_range(1, 3);
		if rand == 1 :
			init_temperate_weights();
		elif rand == 2 :
			init_cold_arid_weights();
		else :
			init_hot_arid_weights();
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
			GV.prairie : 10,
			GV.forest : (40),
			GV.marsh : (10),
			GV.mountain : (40),
			"total" : 100
		}
	if age_class == "medium" :
		tile_weights = {
			GV.shallow_watters : (10),
			GV.prairie : 25,
			GV.forest : (35),
			GV.marsh : (10),
			GV.mountain : (20),
			"total" : 100
		}
	if age_class == "old" :
		tile_weights = {
			GV.shallow_watters : (15),
			GV.prairie : 35,
			GV.forest : (25),
			GV.marsh : (15),
			GV.mountain : (10),
			"total" : 100
		}

func init_hot_arid_weights() :
	if age_class == "recent" :
		tile_weights = {
			GV.savannah : 15,
			GV.dryland : 30,
			GV.desert : 5,
			GV.mountain : 50,
			"total" : 100
		}
	if age_class == "medium" :
		tile_weights = {
			GV.scarces_rocky_islands : 5,
			GV.shallow_watters : 15,
			GV.savannah : 15,
			GV.dryland : 30,
			GV.desert : 5,
			GV.mountain : 30,
			"total" : 100
		}
	if age_class == "old" :
		tile_weights = {
			GV.scarces_rocky_islands : 5,
			GV.shallow_watters : (20),
			GV.savannah : 20,
			GV.dryland : 30,
			GV.desert : 10,
			GV.mountain : 15,
			"total" : 100
		}

func init_cold_arid_weights() :
	if age_class == "recent" :
		tile_weights = {
			GV.steppe : 15,
			GV.taiga : 20,
			GV.highland : 25,
			GV.snowy_mountains : 40,
			"total" : 100
		}
	if age_class == "medium" :
		tile_weights = {
			GV.scarces_rocky_islands : 5,
			GV.shallow_watters : 15,
			GV.steppe : 20,
			GV.taiga : 20,
			GV.highland : 20,
			GV.snowy_mountains : 20,
			"total" : 100
		}
	if age_class == "old" :
		tile_weights = {
			GV.scarces_rocky_islands : 10,
			GV.shallow_watters : 20,
			GV.steppe : 20,
			GV.taiga : 20,
			GV.highland : 15,
			GV.snowy_mountains : 15,
			"total" : 100,
		}

func init_tropical_weights() :
	if age_class == "recent" :
		tile_weights = {
			GV.jungle : 15,
			GV.marsh : 15,
			GV.tropical_highlands : 30,
			GV.mountain : 40,
			"total" : 100
		}
	if age_class == "medium" :
		tile_weights = {
			GV.scarces_luxurious_islands : 5,
			GV.shallow_watters : 10,
			GV.marsh : 15,
			GV.jungle : 25,
			GV.tropical_highlands : 30,
			GV.mountain : 15,
			"total" : 100
		}
	if age_class == "old" :
		tile_weights = {
			GV.scarces_luxurious_islands : 10,
			GV.shallow_watters : 15,
			GV.marsh : 20,
			GV.jungle : 30,
			GV.tropical_highlands : 15,
			GV.mountain : 10,
			"total" : 100,
		}
		
func init_arctic_weights() :
	if age_class == "recent" :
		tile_weights = {
			GV.ice_cap : 40,
			GV.toundra : 5,
			GV.arctic_mainland : 5,
			GV.snowy_mountains : 50,
			"total" : 100
		}
	if age_class == "medium" :
		tile_weights = {
			GV.scarces_icegrasped_islands : 5,
			GV.ice_cap : 40,
			GV.toundra : 15,
			GV.arctic_mainland : 15,
			GV.snowy_mountains : 30,
			"total" : 100
		}
	if age_class == "old" :
		tile_weights = {
			GV.scarces_icegrasped_islands : 10,
			GV.ice_cap : 40,
			GV.toundra : 20,
			GV.arctic_mainland : 20,
			GV.snowy_mountains : 10,
			"total" : 100,
		}
