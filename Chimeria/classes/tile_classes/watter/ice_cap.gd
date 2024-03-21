class_name IceCapTile extends Tile

var texture = "res://sqr/ice_cap.png";
var stream_direction : float = 0.0;
var stream_force : float = 1.0;
var tons_of_biomass_per_square = 0.25 * 1000000;

func _init(xPos : int, yPos : int, tileId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	sprite.texture = load(texture);
	self.category = "watter";
	self.type = GV.ice_cap;
	max_vegetal_biomass = tons_of_biomass_per_square * GV.carbon_levels;
	max_animal_biomass = GV.vegetal_to_animal_biomass_in_ocean_ratio * 8 * max_vegetal_biomass;
	vegetal_biomass = max_vegetal_biomass * 0.5;
	animal_biomass = GV.vegetal_to_animal_biomass_in_ocean_ratio * 4 * vegetal_biomass;
	vegetal_biomass_growth_rate = 1.4 * GV.carbon_levels; 
	animal_biomass_growth_rate = 1.8 * GV.carbon_levels
