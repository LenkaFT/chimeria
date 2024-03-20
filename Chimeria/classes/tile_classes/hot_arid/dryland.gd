class_name DrylandTile extends Tile

var texture = "res://sqr/dryland.png";

func _init(xPos : int, yPos : int, tileId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	sprite.texture = load(texture);
	self.category = "land";
	self.sub_category = "highland";
	self.type = GV.dryland;
