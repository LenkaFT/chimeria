class_name Map
extends CanvasGroup

@export var grid_width = 50;
@export var grid_height = 30;
var number_of_tiles = grid_width * grid_height;
var earth_to_sea_ratio = 0.5;
var available_continent_tiles : int = earth_to_sea_ratio * number_of_tiles;
var tile_size = 64;
var grid = [];
var tile_types = ["prairie", "forest", "mountain", "desert", "sea"];
var continents_nb = 4;
var continents_array : Array[Continent] = [];

func _init():
	create_map();
		

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			var sprite = Sprite2D.new();
			sprite.texture = load("res://sqr/blue_sqr.png");
			add_child(sprite);
			
func get_tile_by_id(id : int) :
	return (grid[id / grid_width - 1][id % grid_width]);

func random_tile_type():
	randomize();
	var rand = RandomNumberGenerator.new().randi() % tile_types.size();
	return tile_types[rand];
	
func random_tile_type_with_weights():
	randomize();
	var rand = RandomNumberGenerator.new().randi() % tile_types.size();
	return tile_types[rand];
	
func create_tile_instance(type : String, x : int, y : int, id : int, continentId : int):
	if type == GV.prairie :
		return 	PrairieTile.new(x, y, id, continentId);
	if type == GV.forest :
		return 	ForestTile.new(x, y, id, continentId);
	if type == GV.mountain :
		return 	MountainTile.new(x, y, id, continentId);
	if type == GV.desert :
		return 	DesertTile.new(x, y, id, continentId);
	if type == GV.sea :
		return 	SeaTile.new(x, y, id, continentId);
#
func generate_random_tile(x : int, y : int, id : int, continentId : int) :
		return (create_tile_instance(random_tile_type(), x, y, id, continentId));
		
func generate_tile_according_to_surroundings(x : int, y : int, id : int, continentId : int) :
	var adjacent_sea = 0;
	var adjacent_prairie = 0;
	var adjacent_forest = 0;
	var adjacent_mountain = 0;
	var adjacent_desert = 0;
	var adjacent_to_continent = false;
	var neigbhours : Array[Tile] = [grid[y][x].getNorthTile(grid),  grid[y][x].getSouthTile(grid), grid[y][x].getEastTile(grid), grid[y][x].getWestTile(grid)]
	for n in neigbhours.size() :
		if neigbhours[n].type == GV.sea :
			adjacent_sea += 1;
		if neigbhours[n].type == GV.prairie :
			adjacent_prairie += 1;
		if neigbhours[n].type == GV.forest :
			adjacent_forest += 1;
		if neigbhours[n].type == GV.mountain :
			adjacent_mountain += 1;
		if neigbhours[n].type == GV.desert :
			adjacent_desert += 1;
		if neigbhours[n].continent != grid[y][x].continent && neigbhours[n].continent != -1:
			adjacent_to_continent = true;


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
		print("Rand X : ", rand_x, " Rand Y ", rand_y);
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
		expand_continents(continents_array[n]);
	
