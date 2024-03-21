class_name ScarcesIcegraspedIslandsTile extends Tile

var texture = "res://sqr/scarces_icegrasped_islands.png";
var stream_direction : float = 0.0;
var stream_force : float = 1.0;
var tons_of_biomass_per_square = 1 * 500000;

func _init(xPos : int, yPos : int, tileId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	sprite.texture = load(texture);
	self.category = "island";
	self.type = GV.scarces_icegrasped_islands;
	max_vegetal_biomass = tons_of_biomass_per_square * GV.carbon_levels;
	max_animal_biomass = GV.vegetal_to_animal_biomass_in_ocean_ratio * 4 * max_vegetal_biomass;
	vegetal_biomass = max_vegetal_biomass * 0.5;
	animal_biomass = GV.vegetal_to_animal_biomass_in_ocean_ratio * vegetal_biomass;
	vegetal_biomass_growth_rate = 1.05 * GV.carbon_levels; 
	animal_biomass_growth_rate = 1.5 * GV.carbon_levels;
