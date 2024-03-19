class_name	Tile 

var id = 0;
var sprite_added_as_children = false;
var continent = -1;
#@export var sprite_scale = GV.sprite_scale
@export var size = GV.tile_size; #* sprite_scale;
var x = 0;
var y = 0;
var sprite = Sprite2D.new();
#var visible : bool = true;
var type;
var category;
var sub_category;

func _init(xPos : int, yPos : int, tileId : int, continentId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	continent = continentId;

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
		
		
func getBiggestNeigbhourHeightDifference(grid : Array, topographic_map : Array) : 
	var neighbours_array = [getNorthTile(grid), getSouthTile(grid), getEastTile(grid), getWestTile(grid)];
	var biggest_height_diff : float = 0.0;
	
	for n in neighbours_array.size() :
		if neighbours_array[n] != null && biggest_height_diff < topographic_map[self.y][self.x] - topographic_map[neighbours_array[n].y][neighbours_array[n].x] :
			biggest_height_diff =  topographic_map[self.y][self.x] - topographic_map[neighbours_array[n].y][neighbours_array[n].x];
	
	return (biggest_height_diff);
	
func getAverageAdjacentHeightsDifference(grid : Array, topographic_map : Array) :
	var neighbours_array = [getNorthTile(grid), getSouthTile(grid), getEastTile(grid), getWestTile(grid)];
	var adjacent_tile_ct = 0;
	var total : float = 0.0;
	
	for n in neighbours_array.size() :
		if neighbours_array[n] != null :
			total +=  (topographic_map[self.y][self.x] - topographic_map[neighbours_array[n].y][neighbours_array[n].y]);
			adjacent_tile_ct += 1;
	
	return (total / adjacent_tile_ct);
