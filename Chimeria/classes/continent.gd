class_name Continent

var name = "weird chunk of earth";
var id = 0;
var epicenter_coo = {"x" : 0, "y" : 0};
var size : int = 0;
var type = "temperate";
var tile_types = ["prairie", "forest", "mountain", "desert"];
var direction_array = GV.direction_array;
var tiles_array : Array[Tile] = [];
var tile_expands_before_reset = 4;

func is_able_to_expand(grid) :
	
	for n in tiles_array.size() :
		if (tiles_array[n].getNorthTile(grid) && tiles_array[n].getNorthTile(grid).continent == -1 ||
		tiles_array[n].getSouthTile(grid) && tiles_array[n].getSouthTile(grid).continent == -1 ||
		tiles_array[n].getEastTile(grid) && tiles_array[n].getEastTile(grid).continent == -1 ||
		tiles_array[n].getWestTile(grid) && tiles_array[n].getWestTile(grid).continent == -1) :
			return (true);
	return (false);
	
func get_able_to_expand_tiles_array(grid) :
	var array : Array = [];
	for n in tiles_array.size() :
		if (tiles_array[n].getNorthTile(grid) && tiles_array[n].getNorthTile(grid).continent == -1 ||
		tiles_array[n].getSouthTile(grid) && tiles_array[n].getSouthTile(grid).continent == -1 ||
		tiles_array[n].getEastTile(grid) && tiles_array[n].getEastTile(grid).continent == -1 ||
		tiles_array[n].getWestTile(grid) && tiles_array[n].getWestTile(grid).continent == -1) :
			array.append(tiles_array[n])
	return (array);
	
func calculate_size(availables_tiles : int, remaining_continents_to_create : int) :
	randomize();
	if remaining_continents_to_create == 1 :
		size = availables_tiles;
		return ;
		
	var shrink_or_grow = RandomNumberGenerator.new().randi() % 2;
	var size_factor;
	
	if shrink_or_grow == 0 :
		size_factor = -1 * (RandomNumberGenerator.new().randf() / 2);
	elif shrink_or_grow == 1 : 
		size_factor = RandomNumberGenerator.new().randf() / 2;
		
	var size_modifier = (availables_tiles / remaining_continents_to_create) * size_factor;
	size = (availables_tiles / remaining_continents_to_create) + size_modifier;
	
func generate_starting_tile(x : int, y : int, tileId : int) :
	randomize();
	var new_tile_type = tile_types[RandomNumberGenerator.new().randi() % tile_types.size()];
	var starting_tile = null;
	if new_tile_type == "prairie" :
		starting_tile = PrairieTile.new(x, y, tileId);
	
	if new_tile_type == "forest" :
		starting_tile = ForestTile.new(x, y, tileId);
	
	if new_tile_type == "mountain" :
		starting_tile = MountainTile.new(x, y, tileId, false);
	
	if new_tile_type == "desert" :
		starting_tile = DesertTile.new(x, y, tileId);
	
	tiles_array.append(starting_tile);
	return (starting_tile);
