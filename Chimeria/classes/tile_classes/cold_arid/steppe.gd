class_name SteppeTile extends Tile

var texture = "res://sqr/steppe_one.png";

func _init(xPos : int, yPos : int, tileId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	sprite.texture = load(texture);
	#sprite.scale *= sprite_scale;
	self.category = "land";
	self.sub_category = "flatland";
	self.type = GV.steppe;
