class_name MarshTile extends Tile

var texture = "res://sqr/marsh_one.png";
var tons_of_biomass_per_square = 40 * 1000000;

func _init(xPos : int, yPos : int, tileId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	sprite.texture = load(texture);
	self.category = "land";
	self.sub_category = "flatland";
	#sprite.scale *= sprite_scale;
	self.type = GV.marsh;
	max_vegetal_biomass = tons_of_biomass_per_square * 3 * GV.carbon_levels;
	max_animal_biomass = GV.vegetal_to_animal_biomass_ratio * max_vegetal_biomass;
	vegetal_biomass = max_vegetal_biomass * 0.5;
	animal_biomass = GV.vegetal_to_animal_biomass_ratio * vegetal_biomass;
	vegetal_biomass_growth_rate = 1.6 * GV.carbon_levels; 
	animal_biomass_growth_rate = 1.1 * GV.carbon_levels;
