class_name Map
extends Node2D

@export var grid_width = GV.map_width;
@export var grid_height = GV.map_height;
var number_of_tiles = grid_width * grid_height;
@export var sea_to_earth_ratio = 0.55;
@export var available_continent_tiles : int = sea_to_earth_ratio * number_of_tiles;
@export var island_distance_to_land = 4;
@export var island_ratio = 0.002;
@export var number_of_island = 40;
@export var island_max_size = 15;
@export var planetary_rotation_direction = "right";
var tile_size = 64;
var grid = [];
#var continents_array : Array[Continent] = [];
var tile_maker = TileMaker.new();
var heat_grid;
var humidity_grid;
var topographic_grid;
#range from 1 to 2, determine luxirousness of the world, 0 : actual earth, 2 : carbonifere earth;
var carbon_lvls = 1;

func _init():
	pass ;
	

func replace_tile(x : int, y : int, new_tile : Tile) :
	grid[y][x] = new_tile;


func diffusion_aggregation_map(continent : Continent, heat_grid, humidity_grid) :
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
				new_tile = tile_maker.randomize_tile(new_tile, self, heat_grid, humidity_grid);
				replace_tile(new_tile.x, new_tile.y, new_tile);
				continent.tiles_array.append(new_tile);
				placed_tiles += 1;
			origin = new_tile;

func make_coast_shallow() :
	for y in grid.size() :
		for x in grid[y].size() :
			if grid[y][x].type == GV.sea :
				randomize();
				var rand = RandomNumberGenerator.new().randi();
				if (grid[y][x].getNorthTile(grid) != null && grid[y][x].getNorthTile(grid).category != "watter" ||
				grid[y][x].getSouthTile(grid) != null && grid[y][x].getSouthTile(grid).category != "watter" ||
				grid[y][x].getEastTile(grid) != null && grid[y][x].getEastTile(grid).category != "watter" ||
				grid[y][x].getWestTile(grid) != null && grid[y][x].getWestTile(grid).category != "watter"):
					replace_tile(x, y, tile_maker.create_tile_instance(GV.shallow_watters, x, y, grid[y][x].id));
					
func make_arctic_seas(heat_grid) :
	for y in grid.size() :
		for x in grid[y].size() :
			if grid[y][x].category == "watter" && heat_grid[y][x] <= 0.20 :
				randomize();
				var rand = RandomNumberGenerator.new().randi();
				if (heat_grid[y][x] <= 0.20 && rand % 8 == 0 ||
				heat_grid[y][x] <= 0.15 && rand % 4 == 0 ||
				heat_grid[y][x] <= 0.1 && rand % 2 == 0 ||
				heat_grid[y][x] <= 0.05) :
					var new_tile =  IceCapTile.new(grid[y][x].x, grid[y][x].y, grid[y][x].id);
					replace_tile(grid[y][x].x, grid[y][x].y, new_tile);

func neighbours_are_land_tile(start_x : int, start_y : int, x : int, y : int, recursion_ct : int) :
	var shortest_distance : float = island_distance_to_land;
	var distance_buffer = island_distance_to_land;
	
	if recursion_ct <= 0 :
		return (island_distance_to_land - 1);
		
	if grid[y][x].getNorthTile(grid) && grid[y][x].getNorthTile(grid).category == "land" :
		return (sqrt((start_x - x) * (start_x - x)  + (start_y - y) * (start_y - y)));
	elif grid[y][x].getSouthTile(grid) && grid[y][x].getSouthTile(grid).category == "land" :
		return (sqrt((start_x - x) * (start_x - x)  + (start_y - y) * (start_y - y)));
	elif grid[y][x].getWestTile(grid) && grid[y][x].getWestTile(grid).category == "land" :
		return (sqrt((start_x - x) * (start_x - x)  + (start_y - y) * (start_y - y)));
	elif grid[y][x].getEastTile(grid) && grid[y][x].getEastTile(grid).category == "land" :	
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
	var is_island_eligible_tile : Array[Tile] = [];
	var recursion_ct = island_distance_to_land;
	var distance = 0;
	
	for y in grid.size() :
		for x in grid[y].size() :
			if grid[y][x].category == "land" :
				continue ;
			else :
				distance = neighbours_are_land_tile(x, y, x, y, recursion_ct);
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

func display_map(top_left_x : int, top_left_y : int, visible_tiles_in_pov_x : int, visible_tiles_in_pov_y : int) :
	
	top_left_x = top_left_x / GV.tile_size;
	top_left_y = top_left_y / GV.tile_size;
	var it_count = top_left_x;
	var y = top_left_y;
	var x = top_left_x;
	var x_index;
	if visible_tiles_in_pov_y > GV.map_height :
		visible_tiles_in_pov_y = GV.map_height;
	while y <= top_left_y + (visible_tiles_in_pov_y) && y < GV.map_height :
		it_count = 0;
		x = top_left_x;
		while x < 0 && it_count <= visible_tiles_in_pov_x :
			x_index = GV.map_width - x % GV.map_width * -1;
			if x_index == GV.map_width :
				x_index = 0;
			if grid[y][x_index].sprite_added_as_children == true :
				remove_child(grid[y][x_index].sprite);
			grid[y][x_index].sprite.position.x = x * GV.tile_size - GV.tile_size * 0.5;
			add_child(grid[y][x_index].sprite);
			grid[y][x_index].sprite_added_as_children = true;
			x += 1;
			it_count += 1;
		while x >= 0 && it_count <= visible_tiles_in_pov_x:
			x_index = x % GV.map_width;
			if grid[y][x_index].sprite_added_as_children == true :
				remove_child(grid[y][x_index].sprite);
				grid[y][x_index].sprite_added_as_children = false;
			grid[y][x_index].sprite.position.x = x * GV.tile_size - GV.tile_size * 0.5;
			add_child(grid[y][x_index].sprite);
			grid[y][x_index].sprite_added_as_children = true;
			x += 1;
			it_count += 1;
		y += 1;
		


func create_map(heat_grid, humidity_grid, topographic_grid):
	self.humidity_grid = humidity_grid;
	self.heat_grid = heat_grid;
	self.topographic_grid = topographic_grid;
	var tile_id = 0;
	for y in grid_height :
		grid.append([])
		for x in grid_width :
			grid[y].append(SeaTile.new(x, y, tile_id))
			tile_id += 1;
			
	for y in grid.size() :
		for x in grid[y].size() :
			var eternal_snow_threshold = 0.5 + heat_grid[y][x] * 0.5;
			if topographic_grid[y][x] < sea_to_earth_ratio :
				continue ;
			elif topographic_grid[y][x] > eternal_snow_threshold  && topographic_grid[y][x] > 0.75:
				replace_tile(x, y, SnowyMountainTile.new(x, y, tile_id));
				continue;
				
			if grid[y][x].isOneTileIsland(grid) :
				replace_tile(x, y, tile_maker.generate_one_tile_island(grid[y][x], self));
				continue ;
				
			var Biggest_hight_diff = grid[y][x].getBiggestNeigbhourHeightDifference(grid, topographic_grid);
			if Biggest_hight_diff > 0.20 || topographic_grid[y][x] > 0.75:
				if heat_grid[y][x] > 0.6 :
					replace_tile(x, y, MountainTile.new(x, y, tile_id, true))
				else : 
					replace_tile(x, y, SnowyMountainTile.new(x, y, tile_id));
			elif Biggest_hight_diff > 0.10 || topographic_grid[y][x] > 0.70:
				replace_tile(x, y, tile_maker.generate_highland_tile(grid[y][x], self));
				#replace_tile(x, y, HighlandTile.new(x, y, tile_id, -1))
			else :
				replace_tile(x, y, tile_maker.generate_lowland_tile(grid[y][x], self));
				#replace_tile(x, y,PrairieTile.new(x, y, tile_id, -1))
	
	
	#place_continents();
	#for n in continents_array.size() :
		#diffusion_aggregation_map(continents_array[n], heat_grid, humidity_grid);
	#place_islands(available_island_spots());
	make_coast_shallow();
	make_arctic_seas(heat_grid);

