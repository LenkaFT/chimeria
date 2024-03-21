class_name Shallow extends Tile

var texture = "res://sqr/shallow_watter_one.png";
var stream_direction : float = 0.0;
var stream_force : float = 1.0;
var tons_of_biomass_per_square = 1 * 1000000;

func _init(xPos : int, yPos : int, tileId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	sprite.texture = load(texture);
	#sprite.scale *= sprite_scale;
	self.category = "watter"
	self.type = GV.shallow_watters;
	max_vegetal_biomass = tons_of_biomass_per_square * GV.carbon_levels;
	max_animal_biomass = GV.vegetal_to_animal_biomass_in_ocean_ratio * 8 * max_vegetal_biomass;
	vegetal_biomass = max_vegetal_biomass * 0.5;
	animal_biomass = GV.vegetal_to_animal_biomass_in_ocean_ratio * 4 * vegetal_biomass;
	vegetal_biomass_growth_rate = 1.4 * GV.carbon_levels; 
	animal_biomass_growth_rate = 1.8 * GV.carbon_levels;
