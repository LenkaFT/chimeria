class_name Map
extends Node2D

@export var grid_width = GV.map_width;
@export var grid_height = GV.map_height;
var number_of_tiles = grid_width * grid_height;
@export var earth_to_sea_ratio = 0.5;
@export var available_continent_tiles : int = earth_to_sea_ratio * number_of_tiles;
@export var island_distance_to_land = 4;
@export var island_ratio = 0.002;
@export var number_of_island = 40;
@export var island_max_size = 15;
@export var planetary_rotation_direction = "right";
var equator = grid_height / 2;
var north_tropic = grid_height / 2 - grid_height / 8;
var south_tropic = grid_height / 2 + grid_height / 8;
var north_polar_circle = grid_height / 16;
var south_polar_circle = grid_height - grid_height / 16;
var tile_size = 64;
var grid = [];
var tile_types = ["prairie", "forest", "mountain", "desert", "sea", "shallow_watters"];
@export var continents_nb = 3;
var continents_array : Array[Continent] = [];
var tile_randomizer = TileRandomizer.new();

func _init():
	pass ;

func random_tile_type():
	randomize();
	var rand = RandomNumberGenerator.new().randi() % tile_types.size();
	return tile_types[rand];
	
func random_with_weights(weights : Dictionary):
	randomize();
	var rand = RandomNumberGenerator.new().randi_range(1, weights["total"]);
	var cursor = 0;
	var type : String;
	for key in weights :
		if key == "total" :
			break;
		cursor += weights[key];
		if cursor >= rand :
			type = key;
			return (type)

func create_tile_instance(type : String, x : int, y : int, id : int, continentId : int):
	if type == GV.prairie :
		return 	PrairieTile.new(x, y, id, continentId);
	elif type == GV.marsh :
		return 	MarshTile.new(x, y, id, continentId);		
	elif type == GV.forest :
		return 	ForestTile.new(x, y, id, continentId);
	elif type == GV.mountain :
		return 	MountainTile.new(x, y, id, continentId);
	elif type == GV.desert :
		return 	DesertTile.new(x, y, id, continentId);
	elif type == GV.sea :
		return 	SeaTile.new(x, y, id, continentId);
	elif type == GV.shallow_watters :
		return 	Shallow.new(x, y, id, continentId);
	elif type == GV.highland :
		return HighlandTile.new(x, y, id, continentId);
	elif type == GV.snowy_mountains :
		return SnowyMountainTile.new(x, y, id, continentId);
	elif type == GV.savannah :
		return SavannahTile.new(x, y, id, continentId);
	elif type == GV.dryland :
		return DrylandTile.new(x, y, id, continentId);
	elif type == GV.jungle :
		return JungleTile.new(x, y, id, continentId);
	elif type == GV.tropical_highlands :
		return TropicalHighlandTile.new(x, y, id, continentId);
	elif type == GV.taiga :
		return TaigaTile.new(x, y, id, continentId);
	elif type == GV.steppe :
		return SteppeTile.new(x, y, id, continentId);
	elif type == GV.toundra :
		return ToundraTile.new(x, y, id, continentId);
	elif type == GV.ice_cap :
		return IceCapTile.new(x, y, id, continentId);
	elif type == GV.arctic_mainland :
		return ArticMainlandTile.new(x, y, id, continentId);
	elif type == GV.scarces_rocky_islands :
		return ScarcesRockyIslandsTile.new(x, y, id, continentId);
	elif type == GV.scarces_luxurious_islands :
		return ScarcesLuxuriousIslandsTile.new(x, y, id, continentId);
	elif type == GV.scarces_icegrasped_islands :
		return ScarcesIcegraspedIslandsTile.new(x, y, id, continentId);
	else :
		return(null) ;
#
func generate_random_tile(x : int, y : int, id : int, continentId : int) :
		return (create_tile_instance(random_tile_type(), x, y, id, continentId));
		
func generate_random_tile_with_weights(x : int, y : int, id : int, continentId : int, weights : Dictionary) :
		var type  = random_with_weights(weights);
		return (create_tile_instance(type, x, y, id, continentId));
		
func generate_weights_according_to_surroundings(x : int, y : int, id : int, continentId : int) :
	var adjacent_sea = 0;
	var adjacent_prairie = 0;
	var adjacent_forest = 0;
	var adjacent_mountain = 0;
	var adjacent_desert = 0;
	var total = 0;
	var adjacent_to_continent = false;
	var neigbhours : Array[Tile] = [grid[y][x].getNorthTile(grid),  grid[y][x].getSouthTile(grid), grid[y][x].getEastTile(grid), grid[y][x].getWestTile(grid)]
	for n in neigbhours.size() :
		if neigbhours[n] && neigbhours[n].type == GV.sea :
			adjacent_sea += 1;
		elif neigbhours[n] && neigbhours[n].type == GV.prairie :
			adjacent_prairie += 1;
		elif neigbhours[n] && neigbhours[n].type == GV.forest :
			adjacent_forest += 1;
		elif neigbhours[n] && neigbhours[n].type == GV.mountain :
			adjacent_mountain += 1;
		elif neigbhours[n] && neigbhours[n].type == GV.desert :
			adjacent_desert += 1;
		if neigbhours[n] && neigbhours[n].continent != grid[y][x].continent && neigbhours[n].continent != -1:
			adjacent_to_continent = true;
	
	var weights : Dictionary;
	if adjacent_to_continent == false :
		weights = {
			GV.shallow_watters : (0),
			GV.prairie : (25 + (adjacent_prairie * 10)),
			GV.forest : (20 + (adjacent_forest * 10)),
			GV.desert : (10 + (adjacent_desert * 10)),
			GV.mountain : (5 + (adjacent_mountain * 10) + (adjacent_sea * 10)),
			"total" : (adjacent_sea + adjacent_prairie + adjacent_forest + adjacent_mountain + adjacent_desert) * 10 + 60
		}
	else :
		weights = {
			GV.shallow_watters : (15 + (adjacent_sea * 10)),
			GV.prairie : (5 + (adjacent_prairie * 10)),
			GV.forest : (5 + (adjacent_forest * 10)),
			GV.desert : (5 + (adjacent_desert * 10)),
			GV.mountain : (30 + (adjacent_mountain * 10)),
			"total" : (adjacent_sea + adjacent_prairie + adjacent_forest + adjacent_mountain + adjacent_desert) * 10 + 60
		}
	return (weights)


func print_grid() :
	for y in grid.size() :
		for x in grid[y].size() :
			print("id : ", grid[y][x].id, " type :", grid[y][x].type)

func replace_tile(x : int, y : int, new_tile : Tile) :
	remove_child(grid[y][x].sprite);
	add_child(new_tile.sprite);
	grid[y][x] = new_tile;

func place_continents():
	randomize();
	for n in continents_nb :
		var rand_x = RandomNumberGenerator.new().randi_range(0, grid_width - 1);
		var rand_y = RandomNumberGenerator.new().randi_range(0, number_of_tiles - 1) % grid_height;

		continents_array.append(Continent.new());
		continents_array[n].id = n;
		continents_array[n].epicenter_coo = {"x" : rand_x, "y" : rand_y};
		continents_array[n].calculate_size(available_continent_tiles, continents_nb - n);
		available_continent_tiles -= continents_array[n].size;
		remove_child(grid[rand_y][rand_x].sprite);
		replace_tile(rand_x, rand_y, 
		continents_array[n].generate_starting_tile(rand_x, rand_y, grid[rand_y][rand_x].id, continents_array[n].id));

func expand_continents(continent : Continent) :
	var placed_tiles = 0;
	while continent.is_able_to_expand(grid) && placed_tiles < continent.size :
		for n in continent.tiles_array.size() :
			randomize();
			var direction = RandomNumberGenerator.new().randi() % 4;
			var will_expand = RandomNumberGenerator.new().randi() % 20;
			
			if will_expand == 0 : 
				placed_tiles += 1;
				continue; 
				
			var north_tile = continent.tiles_array[n].getNorthTile(grid);
			if north_tile && north_tile.continent == -1 && direction == 0:
				var new_tile = generate_random_tile(north_tile.x, north_tile.y, north_tile.id, continent.id);
				replace_tile(new_tile.x, new_tile.y, new_tile);
				continent.tiles_array.append(new_tile);
				placed_tiles += 1;
				continue ;
				
			var south_tile = continent.tiles_array[n].getSouthTile(grid);
			if south_tile && south_tile.continent == -1 && direction == 1:
				var new_tile = generate_random_tile(south_tile.x, south_tile.y, south_tile.id, continent.id);
				replace_tile(new_tile.x, new_tile.y, new_tile);
				continent.tiles_array.append(new_tile);
				placed_tiles += 1;
				continue ;

			var east_tile = continent.tiles_array[n].getEastTile(grid);
			if east_tile && east_tile.continent == -1 && direction == 2:
				var new_tile = generate_random_tile(east_tile.x, east_tile.y, east_tile.id, continent.id);
				replace_tile(new_tile.x, new_tile.y, new_tile);
				continent.tiles_array.append(new_tile);
				placed_tiles += 1;
				continue ;

			var west_tile = continent.tiles_array[n].getWestTile(grid);
			if  west_tile &&  west_tile.continent == -1 && direction == 2 :
				var new_tile = generate_random_tile( west_tile.x,  west_tile.y,  west_tile.id, continent.id);
				replace_tile(new_tile.x, new_tile.y, new_tile);
				continent.tiles_array.append(new_tile);
				placed_tiles += 1;
				continue ;

func diffusion_aggregation_map(continent : Continent) :
	var placed_tiles = 0;
	var new_tile;
	var origin : Tile = grid[continent.epicenter_coo.y][continent.epicenter_coo.x];
	
	while continent.is_able_to_expand(grid) && placed_tiles < continent.size :
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
				origin = continent.tiles_array[RandomNumberGenerator.new().randi_range(0, continent.tiles_array.size() - 1)];
				break ;
			
			else :
				new_tile = generate_random_tile( new_tile.x, new_tile.y, new_tile.id, continent.id);
				replace_tile(new_tile.x, new_tile.y, new_tile);
				continent.tiles_array.append(new_tile);
				placed_tiles += 1;
			origin = new_tile;

func rework_continents(continent : Continent) :
	for n in continent.tiles_array.size() :
		var tile = continent.tiles_array[n];
		var weights : Dictionary = generate_weights_according_to_surroundings(tile.x, tile.y, tile.id, continent.id);
		var new_tile = generate_random_tile_with_weights(tile.x, tile.y, tile.id, continent.id, weights);
		replace_tile(tile.x, tile.y, new_tile);
		continent.tiles_array[n] = new_tile;

func make_coast_shallow() :
	for y in grid.size() :
		for x in grid[y].size() :
			if grid[y][x].type == GV.sea :
				if (grid[y][x].getNorthTile(grid) != null && grid[y][x].getNorthTile(grid).category != "watter" ||
				grid[y][x].getSouthTile(grid) != null && grid[y][x].getSouthTile(grid).category != "watter" ||
				grid[y][x].getEastTile(grid) != null && grid[y][x].getEastTile(grid).category != "watter" ||
				grid[y][x].getWestTile(grid) != null && grid[y][x].getWestTile(grid).category != "watter"):
					replace_tile(x, y, create_tile_instance(GV.shallow_watters, x, y, grid[y][x].id, grid[y][x].continent));

func neighbours_are_land_tile(start_x : int, start_y : int, x : int, y : int, recursion_ct : int) :
	var shortest_distance : float = island_distance_to_land;
	var distance_buffer = island_distance_to_land;
	
	if recursion_ct <= 0 :
		return (island_distance_to_land - 1);
		
	if grid[y][x].getNorthTile(grid) && grid[y][x].getNorthTile(grid).category == "land" :
		#print("North : ", sqrt((start_x - x) * (start_x - x)  + (start_y - y) * (start_y - y)));
		return (sqrt((start_x - x) * (start_x - x)  + (start_y - y) * (start_y - y)));
	elif grid[y][x].getSouthTile(grid) && grid[y][x].getSouthTile(grid).category == "land" :
		#print("South : ", sqrt((start_x - x) * (start_x - x)  + (start_y - y) * (start_y - y)));
		return (sqrt((start_x - x) * (start_x - x)  + (start_y - y) * (start_y - y)));
	elif grid[y][x].getWestTile(grid) && grid[y][x].getWestTile(grid).category == "land" :
		#print("West : ", sqrt((start_x - x) * (start_x - x)  + (start_y - y) * (start_y - y)));
		return (sqrt((start_x - x) * (start_x - x)  + (start_y - y) * (start_y - y)));
	elif grid[y][x].getEastTile(grid) && grid[y][x].getEastTile(grid).category == "land" :	
		#print("East : ", sqrt((start_x - x) * (start_x - x)  + (start_y - y) * (start_y - y)));
		return (sqrt((start_x - x) * (start_x - x)  + (start_y - y) * (start_y - y)));
	else :
		recursion_ct -= 1;
		if grid[y][x].getNorthTile(grid) != null :
			distance_buffer = neighbours_are_land_tile(start_x, start_y, grid[y][x].getNorthTile(grid).x, grid[y][x].getNorthTile(grid).y, recursion_ct)
		if shortest_distance > distance_buffer :
			shortest_distance = distance_buffer;
		
		if grid[y][x].getSouthTile(grid) != null :
			distance_buffer = neighbours_are_land_tile(start_x, start_y, grid[y][x].getSouthTile(grid).x, grid[y][x].getSouthTile(grid).y, recursion_ct)
		if shortest_distance > distance_buffer :
			shortest_distance = distance_buffer;
		
		if grid[y][x].getWestTile(grid) != null :
			distance_buffer = neighbours_are_land_tile(start_x, start_y, grid[y][x].getWestTile(grid).x, grid[y][x].getWestTile(grid).y, recursion_ct)
		if shortest_distance > distance_buffer :
			shortest_distance = distance_buffer;
			
		if grid[y][x].getEastTile(grid) != null :
			distance_buffer = neighbours_are_land_tile(start_x, start_y, grid[y][x].getEastTile(grid).x, grid[y][x].getEastTile(grid).y, recursion_ct)
		if shortest_distance > distance_buffer :
			shortest_distance = distance_buffer;
		return (shortest_distance);
		

func available_island_spots() :
	#var visited_tiles : Array[int] = [grid[start_y][start_x].id];
	var is_island_eligible_tile : Array[Tile] = [];
	var recursion_ct = island_distance_to_land;
	var distance = 0;
	
	for y in grid.size() :
		for x in grid[y].size() :
			if grid[y][x].category == "land" :
				continue ;
			else :
				distance = neighbours_are_land_tile(x, y, x, y, recursion_ct);
				#print("for tile : ", x, " | ", y, " distance = ", distance);
				if distance >= island_distance_to_land - 1:
					is_island_eligible_tile.append(grid[y][x]);
	return (is_island_eligible_tile);

		
func place_islands(eligible_tiles : Array[Tile]) :
	randomize();
	var random_index_array : Array[int] = [];
	
	for n in number_of_island:
		random_index_array.append(RandomNumberGenerator.new().randi_range(0, eligible_tiles.size() - 1))
	
	for n in random_index_array.size() :
		var island = Island.new(eligible_tiles[random_index_array[n]], island_max_size, self);
		island.expand_island(grid, eligible_tiles, self);

func rework_map_according_to_weather(heat_grid, humidity_grid) :
	for continent in continents_array :
		for n in continent.tiles_array.size() :
			var tile = continent.tiles_array[n];
			var weights : Dictionary = generate_weights_according_to_surroundings(tile.x, tile.y, tile.id, continent.id);
			var new_tile = tile_randomizer.randomize_tile(tile, self, heat_grid, humidity_grid);
			replace_tile(tile.x, tile.y, new_tile);
			continent.tiles_array[n] = new_tile;
	for y in grid.size() :
		for x in grid[y].size() :
			if grid[y][x].category == "watter" && heat_grid[y][x] <= 0.20 :
				randomize();
				var rand = RandomNumberGenerator.new().randi();
				if (heat_grid[y][x] <= 0.20 && rand % 8 == 0 ||
				heat_grid[y][x] <= 0.15 && rand % 4 == 0 ||
				heat_grid[y][x] <= 0.1 && rand % 2 == 0 ||
				heat_grid[y][x] <= 0.05) :
					var new_tile = IceCapTile.new(grid[y][x].x, grid[y][x].y, grid[y][x].id, grid[y][x].continent);
					replace_tile(grid[y][x].x, grid[y][x].y, new_tile);

func create_map():
	var tile_id = 0;
	for y in grid_height :
		grid.append([])
		for x in grid_width :
			grid[y].append(SeaTile.new(x, y, tile_id, -1))
			add_child(grid[y][x].sprite);
			tile_id += 1;
	
	place_continents();
	for n in continents_array.size() :
		## Oil spill
		# expand_continents(continents_array[n]);
		## Agreg
		diffusion_aggregation_map(continents_array[n]);
	for n in continents_array.size() :
		rework_continents(continents_array[n]);
	place_islands(available_island_spots());
	make_coast_shallow();

