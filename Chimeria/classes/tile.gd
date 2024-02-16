class_name	Tile 

var id = 0;
var continent = -1;
@export var sprite_scale = 0.4
@export var size = 64 * sprite_scale;
var x = 0;
var y = 0;
var sprite = Sprite2D.new();
var visible : bool = true;
var type;

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
