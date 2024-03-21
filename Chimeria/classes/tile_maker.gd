class_name TileMaker;

var temperate_weights = {
	GV.prairie : 35,
	GV.forest : 30,
	GV.highland : 15,
	GV.mountain : 10,
	GV.marsh : 10,
	"total" : 100
};
var temperate_flatland_weights = {
	GV.prairie : 50,
	GV.forest : 50,
	"total" : 100
};
var temperate_highland_weights = {
	GV.highland : 30,
	GV.wooded_highland : 70,
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

var hot_arid_highland_weights = {
	GV.dryland : 100,
	"total" : 100
};

var hot_arid_flatland_weights = {
	GV.savannah : 50,
	GV.alluviale_plain : 0,
	GV.desert : 25,
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

func create_tile_instance(type : String, x : int, y : int, id : int):
	if type == GV.prairie :
		return 	PrairieTile.new(x, y, id);
	elif type == GV.marsh :
		return 	MarshTile.new(x, y, id);		
	elif type == GV.forest :
		return 	ForestTile.new(x, y, id);
	elif type == GV.mountain :
		return 	MountainTile.new(x, y, id, false);
	elif type == GV.wooded_mountain :
		return 	MountainTile.new(x, y, id, true);
	elif type == GV.desert :
		return 	DesertTile.new(x, y, id);
	elif type == GV.sea :
		return 	SeaTile.new(x, y, id);
	elif type == GV.shallow_watters :
		return 	Shallow.new(x, y, id);
	elif type == GV.highland :
		return HighlandTile.new(x, y, id, false);
	elif type == GV.wooded_highland :
		return HighlandTile.new(x, y, id, true);
	elif type == GV.snowy_mountains :
		return SnowyMountainTile.new(x, y, id);
	elif type == GV.savannah :
		return SavannahTile.new(x, y, id);
	elif type == GV.dryland :
		return DrylandTile.new(x, y, id);
	elif type == GV.jungle :
		return JungleTile.new(x, y, id);
	elif type == GV.tropical_highlands :
		return TropicalHighlandTile.new(x, y, id);
	elif type == GV.taiga :
		return TaigaTile.new(x, y, id);
	elif type == GV.steppe :
		return SteppeTile.new(x, y, id);
	elif type == GV.toundra :
		return ToundraTile.new(x, y, id);
	elif type == GV.ice_cap :
		return IceCapTile.new(x, y, id);
	elif type == GV.arctic_mainland :
		return ArticMainlandTile.new(x, y, id);
	elif type == GV.scarces_rocky_islands :
		return ScarcesRockyIslandsTile.new(x, y, id);
	elif type == GV.scarces_luxurious_islands :
		return ScarcesLuxuriousIslandsTile.new(x, y, id);
	elif type == GV.scarces_icegrasped_islands :
		return ScarcesIcegraspedIslandsTile.new(x, y, id);
	else :
		return(null) ;
		
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
	
func randomize_tile_with_prestablished_weights(tile, weights) :
	var new_tile_type = random_with_weights(weights);
	return(create_tile_instance(new_tile_type, tile.x, tile.y, tile.id));

func is_hot_humid(x, y, map : Map) :
	if map.heat_grid[y][x] > 0.7 && map.humidity_grid[y][x] >= 0.7 :
		return (true);
	return (false);
	
func is_hot_arid(x, y, map : Map) :
	if map.heat_grid[y][x] > 0.7 && map.humidity_grid[y][x] < 0.4 :
		return (true);
	return (false);

func is_polar(x, y, map : Map) :
	if map.heat_grid[y][x] < 0.2 :
		return (true);
	return (false);
	
func is_cold_humid(x, y, map : Map) :
	if map.heat_grid[y][x] < 0.4 && map.humidity_grid[y][x] >= 0.5 :
		return (true);
	return (false);
	
func is_cold_arid(x, y, map : Map) :
	if map.heat_grid[y][x] < 0.4 && map.humidity_grid[y][x] < 0.5 :
		return (true);

func temperate_highland(tile : Tile, map : Map) :
	var adjacent_tiles_dic = tile.get_adjacents_tiles_types(map.grid);
	var weights = temperate_highland_weights.duplicate(true);
	
	weights[GV.wooded_highland] += adjacent_tiles_dic["forest"] * 10 - adjacent_tiles_dic["flatland"] * 10;
	weights[GV.highland] += adjacent_tiles_dic["flatland"] * 10 - adjacent_tiles_dic["forest"] * 10;
	weights["total"] = weights[GV.wooded_highland] + weights[GV.highland];
	
	var new_tile : Tile = randomize_tile_with_prestablished_weights(tile, weights);
	return (new_tile);

func tropical_lowland(tile : Tile, map : Map) :
	var average_heights_diff = tile.getAverageAdjacentHeightsDifference(map.grid, map.topographic_grid);
	if average_heights_diff >= -0.05 &&  average_heights_diff <= 0.05:
		return (MarshTile.new(tile.x, tile.y, tile.id));
	return (JungleTile.new(tile.x, tile.y, tile.id));
	
func hot_arid_lowland(tile : Tile, map : Map) :
	if map.heat_grid[tile.y][tile.x] >= 0.9 :
		return (DesertTile.new(tile.x, tile.y, tile.id));
	return (SavannahTile.new(tile.x, tile.y, tile.id));
	
func polar(tile : Tile, map : Map) :
	if map.heat_grid[tile.y][tile.x] >= 0.15 :
		return (ToundraTile.new(tile.x, tile.y, tile.id));
	return (ArticMainlandTile.new(tile.x, tile.y, tile.id));

func cold_humid_lowland(tile : Tile, map : Map) :
	var average_heights_diff = tile.getAverageAdjacentHeightsDifference(map.grid, map.topographic_grid);
	if average_heights_diff >= -0.05 &&  average_heights_diff <= 0.05:
		return (MarshTile.new(tile.x, tile.y, tile.id));
	else :
		return(TaigaTile.new(tile.x, tile.y, tile.id));
		
func temperate_lowland(tile : Tile, map : Map) :
	var average_heights_diff = tile.getAverageAdjacentHeightsDifference(map.grid, map.topographic_grid);
	if average_heights_diff >= -0.05 &&  average_heights_diff <= 0.05:
		if  map.humidity_grid[tile.y][tile.x] > 0.55 :
			return (MarshTile.new(tile.x, tile.y, tile.id));
		return (PrairieTile.new(tile.x, tile.y, tile.id));
	else :
		var adjacent_tiles_dic = tile.get_adjacents_tiles_types(map.grid);
		var weights = temperate_flatland_weights.duplicate(true);
		
		weights[GV.prairie] += adjacent_tiles_dic["forest"] * 12.5 - adjacent_tiles_dic["flatland"] * 12.5;
		weights[GV.forest] += adjacent_tiles_dic["flatland"] * 12.5 - adjacent_tiles_dic["forest"] * 12.5;
		weights["total"] = weights[GV.forest] + weights[GV.prairie];
		
		return (randomize_tile_with_prestablished_weights(tile, weights));
	

func generate_highland_tile(tile : Tile, map : Map) :
	if is_hot_humid(tile.x, tile.y, map) :
		return (TropicalHighlandTile.new(tile.x, tile.y, tile.id));
	elif is_hot_arid(tile.x, tile.y, map) :
		return (DrylandTile.new(tile.x, tile.y, tile.id))
	elif is_polar(tile.x, tile.y, map) :
		return(ArticMainlandTile.new(tile.x, tile.y, tile.id))
	elif is_cold_humid(tile.x, tile.y, map) :
		return (HighlandTile.new(tile.x, tile.y, tile.id, false));
	elif is_cold_arid(tile.x, tile.y, map) :
		return (DrylandTile.new(tile.x, tile.y, tile.id));
	else : 
		return (temperate_highland(tile, map));
		#return (DesertTile.new(tile.x, tile.y, tile.id))
		
func generate_lowland_tile(tile : Tile, map : Map) :
	if is_hot_humid(tile.x, tile.y, map) :
		return (tropical_lowland(tile, map));
	elif is_hot_arid(tile.x, tile.y, map) :
		return (hot_arid_lowland(tile, map));
	elif is_polar(tile.x, tile.y, map) :
		return(polar(tile, map))
	elif is_cold_humid(tile.x, tile.y, map) :
		return (cold_humid_lowland(tile, map));
	elif is_cold_arid(tile.x, tile.y, map) :
		return (SteppeTile.new(tile.x, tile.y, tile.id));
	else : 
		return (temperate_lowland(tile, map));

func generate_one_tile_island(tile : Tile, map : Map) :
	if is_hot_humid(tile.x, tile.y, map) :
		return (ScarcesLuxuriousIslandsTile.new(tile.x, tile.y, tile.id));
	elif is_polar(tile.x, tile.y, map) :
		return(ScarcesIcegraspedIslandsTile.new(tile.x, tile.y, tile.id))
	else : 
		return (ScarcesRockyIslandsTile.new(tile.x, tile.y, tile.id));
