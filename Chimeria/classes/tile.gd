class_name	Tile 

var id = 0;
var sprite_added_as_children = false;
var continent = -1;
@export var size = GV.tile_size; #* sprite_scale;
var x = 0;
var y = 0;
var sprite = Sprite2D.new();
var type;
var category;
var sub_category;

## both in tons;
var max_vegetal_biomass = 0.0;
var max_animal_biomass = 0.0;

## both in tons;
var vegetal_biomass = 0.0;
var animal_biomass = 0.0;

# range from 0 to 1; biomass * GR each tick is added to the biomass each tick;
var vegetal_biomass_growth_rate = 0.0;
var animal_biomass_growth_rate = 0.0;


func _init(xPos : int, yPos : int, tileId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	

func getNorthTile(grid : Array) -> Tile:
	if y == 0 :
		return (null);
	else :
		return (grid[y - 1][x]);

func getSouthTile(grid : Array) -> Tile:
	if y == grid.size() - 1:
		return (null)
	else :
		return (grid[y + 1][x])

func getWestTile(grid : Array) -> Tile:
	if x == 0:
		## Round Earth
		return (grid[y][grid[y].size() - 1])
		## Flat Earth
		#return (null);
	else :
		return (grid[y][x - 1]);

func getEastTile(grid : Array) -> Tile:
	if x == grid[y].size() - 1:
		## Round Earth
		return (grid[y][0])
		## Flat Earth
		#return (null);
	else :
		return (grid[y][x + 1]);
		

func get_adjacents_tiles_types(grid) :
	var neighbours_array : Array[Tile] = [self.getNorthTile(grid), self.getSouthTile(grid), self.getEastTile(grid), self.getWestTile(grid)]
	var adjacent_types_dic = {
		"highland" : 0,
		"mountain" : 0,
		"flatland" : 0,
		"forest" : 0,
		"watter" : 0
	}
	
	for n in neighbours_array.size() :
		if neighbours_array[n] == null :
			continue;
		elif neighbours_array[n].sub_category == "highland" :
			adjacent_types_dic["highland"] += 1;
		elif neighbours_array[n].sub_category == "mountain" :
			adjacent_types_dic["mountain"] += 1;
		elif neighbours_array[n].sub_category == "flatland" :
			adjacent_types_dic["flatland"] += 1;
		elif neighbours_array[n].sub_category == "forest" :
			adjacent_types_dic["forest"] += 1;
		elif neighbours_array[n].category == "watter" :
			adjacent_types_dic["watter"] += 1;
		
	return adjacent_types_dic;

func getBiggestNeigbhourHeightDifference(grid : Array, topographic_map : Array) : 
	var neighbours_array = [getNorthTile(grid), getSouthTile(grid), getEastTile(grid), getWestTile(grid)];
	var biggest_height_diff : float = 0.0;
	
	for n in neighbours_array.size() :
		if neighbours_array[n] != null && biggest_height_diff < topographic_map[self.y][self.x] - topographic_map[neighbours_array[n].y][neighbours_array[n].x] :
			biggest_height_diff =  topographic_map[self.y][self.x] - topographic_map[neighbours_array[n].y][neighbours_array[n].x];
	
	return (biggest_height_diff);
	
func isOneTileIsland(grid : Array) :
	var neighbours_array = [getNorthTile(grid), getSouthTile(grid), getEastTile(grid), getWestTile(grid)];
	for n in neighbours_array.size() :
		if neighbours_array[n] != null && neighbours_array[n].category != "watter" :
			return (false);
	return (true);
	
func getAverageAdjacentHeightsDifference(grid : Array, topographic_map : Array) :
	var neighbours_array = [getNorthTile(grid), getSouthTile(grid), getEastTile(grid), getWestTile(grid)];
	var adjacent_tile_ct = 0;
	var total : float = 0.0;
	
	for n in neighbours_array.size() :
		if neighbours_array[n] != null :
			total +=  (topographic_map[self.y][self.x] - topographic_map[neighbours_array[n].y][neighbours_array[n].y]);
			adjacent_tile_ct += 1;
	
	return (total / adjacent_tile_ct);
