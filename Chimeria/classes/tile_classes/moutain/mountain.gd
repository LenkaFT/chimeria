class_name MountainTile extends Tile

var texture = "res://sqr/mountain_one.png";

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
