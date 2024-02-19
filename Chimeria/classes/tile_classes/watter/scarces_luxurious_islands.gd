class_name ScarcesLuxuriousIslandsTile extends Tile

var texture = "res://sqr/scarces_luxurious_islands.png";
var category = "watter"

func _init(xPos : int, yPos : int, tileId : int, continentId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	continent = continentId;
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	sprite.texture = load(texture);
	sprite.scale *= sprite_scale;
	self.type = GV.scarces_luxurious_islands;
