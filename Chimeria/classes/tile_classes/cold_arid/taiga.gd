class_name TaigaTile extends Tile

var texture = "res://sqr/ugliest_taiga_ever.png";

func _init(xPos : int, yPos : int, tileId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	sprite.texture = load(texture);
	self.category = "land";
	self.sub_category = "forest";
	self.type = GV.taiga;
