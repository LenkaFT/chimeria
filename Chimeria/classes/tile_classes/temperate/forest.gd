class_name ForestTile extends Tile

var texture = "res://sqr/forest_one.png";
var tons_of_biomass_per_square = 100 * 10000000;

func _init(xPos : int, yPos : int, tileId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	sprite.texture = load(texture);
	self.category = "land";
	self.sub_category = "forest";
	#sprite.scale *= sprite_scale;
	self.type = GV.forest;
	max_vegetal_biomass = tons_of_biomass_per_square * 4 * GV.carbon_levels;
	max_animal_biomass = GV.vegetal_to_animal_biomass_ratio * 2 * max_vegetal_biomass;
	vegetal_biomass = max_vegetal_biomass * 0.5;
	animal_biomass = GV.vegetal_to_animal_biomass_ratio * 2 * vegetal_biomass;
	vegetal_biomass_growth_rate = 1.5 * GV.carbon_levels; 
	animal_biomass_growth_rate = 1.5 * GV.carbon_levels;
