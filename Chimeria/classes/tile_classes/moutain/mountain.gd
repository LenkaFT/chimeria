class_name MountainTile extends Tile

var texture = "res://sqr/mountain_one.png";
var tons_of_biomass_per_square = 15 * 1000000;

func _init(xPos : int, yPos : int, tileId : int, wooded : bool): 
	x = xPos;
	y = yPos;
	id = tileId;
	
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	if wooded == true :
		self.texture = "res://sqr/wooded_mountain.png"
	sprite.texture = load(texture);
	self.category = "land";
	self.sub_category = "mountain";
	#sprite.scale *= sprite_scale;
	self.type = GV.mountain;
	max_vegetal_biomass = tons_of_biomass_per_square * 2 * GV.carbon_levels;
	max_animal_biomass = GV.vegetal_to_animal_biomass_ratio * 2 * max_vegetal_biomass;
	vegetal_biomass = max_vegetal_biomass * 0.5;
	animal_biomass = GV.vegetal_to_animal_biomass_ratio * 2 * vegetal_biomass;
	vegetal_biomass_growth_rate = 1.3 * GV.carbon_levels; 
	animal_biomass_growth_rate = 1.3 * GV.carbon_levels;
