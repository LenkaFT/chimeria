class_name OddsCalculator


var tiles_types : Array = GV.tiles_types;
var base_odds : float;
var odds_dictionnary = {};
var odds_array : Array = [];

func _init() :

	base_odds = 1 / float(tiles_types.size()) * 100;
	for n in GV.tiles_types.size() :
		odds_dictionnary[tiles_types[n]] = base_odds;

func _reset_odds_dic() : 
	for n in GV.tile_type.size() :
		odds_dictionnary[GV.tile_type[n]] = base_odds;

func _tweak_types_odds(tile : Tile) :
	var adjacent_prairie = 0;
	var adjacent_forest = 0;
	var adjacent_mountain = 0;
	var adjacent_desert = 0;
	var adjacent_sea = 0;
	var adjacent_continent = 0;
	
	for n in tile.neighbours :
		if tile.neighbours[n] == null :
			continue ;
		if tile.neighbours[n].type == GV.prairie :
			adjacent_prairie += 1;
		if tile.neighbours[n].type == GV.forest :
			adjacent_forest += 1;
		if tile.neighbours[n].type == GV.mountain :
			adjacent_mountain += 1;
		if tile.neighbours[n].type == GV.desert :
			adjacent_desert += 1;
		if tile.neighbours[n].type == GV.sea :
			adjacent_sea += 1;
		if tile.neighbours[n].belongs_to_continent != tile.belongs_to_continent :
			adjacent_continent += 1;
			
	if adjacent_continent > 0 :
		odds_dictionnary[GV.mountain] = (odds_dictionnary[GV.mountain] + odds_dictionnary[GV.prairie]) * 0.8;
		odds_dictionnary[GV.prairie] = (odds_dictionnary[GV.mountain] + odds_dictionnary[GV.prairie]) * 0.2;
		odds_dictionnary[GV.sea] = (odds_dictionnary[GV.sea] + odds_dictionnary[GV.forest]) * 0.7;
		odds_dictionnary[GV.forest] = (odds_dictionnary[GV.sea] + odds_dictionnary[GV.forest]) * 0.3;
		return ;
		
	if adjacent_prairie > 0 :
		odds_dictionnary[GV.prairie] = (odds_dictionnary[GV.desert] + odds_dictionnary[GV.prairie]) * (0.5 + adjacent_prairie * 0.1);
		odds_dictionnary[GV.desert] = (odds_dictionnary[GV.desert] + odds_dictionnary[GV.prairie]) * (0.5 - adjacent_prairie * 0.1);
		odds_dictionnary[GV.prairie] = (odds_dictionnary[GV.mountain] + odds_dictionnary[GV.prairie]) * (0.5 + adjacent_prairie * 0.1);
		odds_dictionnary[GV.mountain] = (odds_dictionnary[GV.mountain] + odds_dictionnary[GV.prairie]) * (0.5 - adjacent_prairie * 0.1);
		
	if adjacent_forest > 0 :
		odds_dictionnary[GV.forest] = (odds_dictionnary[GV.sea] + odds_dictionnary[GV.forest]) * (0.5 + adjacent_forest * 0.1);
		odds_dictionnary[GV.sea] = (odds_dictionnary[GV.sea] + odds_dictionnary[GV.forest]) * (0.5 - adjacent_forest * 0.1);
		odds_dictionnary[GV.mountain] = (odds_dictionnary[GV.mountain] + odds_dictionnary[GV.desert]) * (0.5 + adjacent_forest * 0.1);
		odds_dictionnary[GV.desert] = (odds_dictionnary[GV.mountain] + odds_dictionnary[GV.desert]) * (0.5 - adjacent_forest * 0.1);
		
	if adjacent_mountain > 0 :
		odds_dictionnary[GV.mountain] = (odds_dictionnary[GV.mountain] + odds_dictionnary[GV.sea]) * (0.5 + adjacent_mountain * 0.1);
		odds_dictionnary[GV.sea] = (odds_dictionnary[GV.mountain] + odds_dictionnary[GV.sea]) * (0.5 - adjacent_mountain * 0.1);
		odds_dictionnary[GV.forest] = (odds_dictionnary[GV.prairie] + odds_dictionnary[GV.forest]) * (0.5 + adjacent_mountain * 0.1);
		odds_dictionnary[GV.prairie] = (odds_dictionnary[GV.prairie] + odds_dictionnary[GV.forest]) * (0.5 - adjacent_mountain * 0.1);
	
	if adjacent_desert > 0 : 
		odds_dictionnary[GV.desert] = (odds_dictionnary[GV.forest] + odds_dictionnary[GV.desert]) * (0.5 + adjacent_desert * 0.1);
		odds_dictionnary[GV.forest] = (odds_dictionnary[GV.forest] + odds_dictionnary[GV.desert]) * (0.5 - adjacent_desert * 0.1);
		odds_dictionnary[GV.desert] = (odds_dictionnary[GV.prairie] + odds_dictionnary[GV.desert]) * (0.5 + adjacent_desert * 0.1);
		odds_dictionnary[GV.prairie] = (odds_dictionnary[GV.prairie] + odds_dictionnary[GV.desert]) * (0.5 - adjacent_desert * 0.1);

func _build_odds_array() :
	var sum : float = 0;
	for n in odds_dictionnary :
		sum += odds_dictionnary[n];
		odds_array.append(sum);
	
func randomize_tile_type(tile : Tile) :
	randomize();
	_tweak_types_odds(tile)
	_build_odds_array();
	var index = 0;
	
	for n in odds_array.size() :
		var rand = RandomNumberGenerator.new().randf_range(0, 100)
		if rand < odds_array[n] :
			return (tiles_types[n]);
