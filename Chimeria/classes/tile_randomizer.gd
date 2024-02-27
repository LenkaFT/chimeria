class_name TileRandomizer;

var temperate_weights = {
	GV.prairie : 35,
	GV.forest : 30,
	GV.highland : 15,
	GV.mountain : 10,
	GV.marsh : 10,
	"total" : 100
};
var hot_arid_weights = {
	GV.savannah : 35,
	GV.alluviale_plain : 0,
	GV.dryland : 30,
	GV.desert : 25,
	GV.mountain : 10,
	"total" : 100
};

var cold_arid_weights = {
	GV.steppe : 60,
	GV.highland : 20,
	GV.mountain : 20,
	"total" : 100
};

var cold_humid_weights = {
	GV.taiga : 40,
	GV.marsh : 20,
	GV.highland : 20,
	GV.mountain : 20,
	"total" : 100
};

var equatorial_weights = {
	GV.jungle : 40,
	GV.tropical_highlands : 30,
	GV.marsh : 15,
	GV.mountain : 15,
	"total" : 100
};
var arctic_weights = {
	GV.ice_cap : 20,
	GV.arctic_mainland : 40,
	GV.snowy_mountains : 30,
	GV.toundra : 10,
	
	"total" : 100
};

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
		
func random_with_weights(weights : Dictionary):
	randomize();
	var rand = RandomNumberGenerator.new().randi_range(1, weights["total"]);
	var cursor = 0;
	var type : String;
	for key in weights :
		print("cursor = ")
		if key == "total" :
			break;
		cursor += weights[key];
		if cursor >= rand :
			type = key;
			return (type)

func randomize_tile(tile : Tile, map : Map, heat_grid, humidity_grid) :
	var weights;
	if heat_grid[tile.y][tile.x] > 0.7 && humidity_grid[tile.y][tile.x] >= 0.5 :
		weights = equatorial_weights;
	elif heat_grid[tile.y][tile.x] > 0.7 && humidity_grid[tile.y][tile.x] < 0.5 :
		weights = hot_arid_weights ;
	elif  heat_grid[tile.y][tile.x] < 0.2 :
		weights = arctic_weights;
	elif heat_grid[tile.y][tile.x] < 0.5 :
		weights = cold_humid_weights;
	elif heat_grid[tile.y][tile.x] < 0.5 && humidity_grid[tile.y][tile.x] < 0.4 :
		weights = cold_arid_weights;
	else : 
		weights = temperate_weights;
	
	print("weights : ", weights);
	var new_tile_type = random_with_weights(weights);
	print(new_tile_type);
	return(create_tile_instance(new_tile_type, tile.x, tile.y, tile.id, tile.continent));
