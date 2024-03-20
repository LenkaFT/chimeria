class_name HighlandTile extends Tile

var texture = "res://sqr/highland.png";

func _init(xPos : int, yPos : int, tileId : int, wooded : bool): 
	x = xPos;
	y = yPos;
	id = tileId;
	
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	if wooded == true :
		self.texture = "res://sqr/wooded_highland.png"
	sprite.texture = load(texture);
	self.category = "land";
	self.sub_category = "highland";
	self.type = GV.highland;
