class_name IceCapTile extends Tile

var texture = "res://sqr/ice_cap.png";
var category = "watter";
var stream_direction : float = 0.0;
var stream_force : float = 0.0;

func _init(xPos : int, yPos : int, tileId : int, continentId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	continent = continentId;
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	sprite.texture = load(texture);
	#sprite.scale *= sprite_scale;
	self.type = GV.ice_cap;