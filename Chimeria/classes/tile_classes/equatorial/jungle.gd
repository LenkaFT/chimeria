class_name JungleTile extends Tile

var texture = "res://sqr/jungle_one.png";


func _init(xPos : int, yPos : int, tileId : int, continentId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	continent = continentId;
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	sprite.texture = load(texture);
	self.category = "land";
	self.sub_category = "forest";
	self.type = GV.jungle;
