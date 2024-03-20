class_name IceCapTile extends Tile

var texture = "res://sqr/ice_cap.png";
var stream_direction : float = 0.0;
var stream_force : float = 1.0;

func _init(xPos : int, yPos : int, tileId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	sprite.texture = load(texture);
	self.category = "watter";
	self.type = GV.ice_cap;
