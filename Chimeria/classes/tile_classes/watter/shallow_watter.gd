class_name Shallow extends Tile

var texture = "res://sqr/shallow_watter_one.png";
var category = "watter"
var stream_direction : float = 0.0;
var stream_force : float = 0.0;
var distance

func _init(xPos : int, yPos : int, tileId : int, continentId : int): 
	x = xPos;
	y = yPos;
	id = tileId;
	continent = continentId;
	sprite.position.x = xPos * size + (size * 0.5);
	sprite.position.y = yPos * size + (size * 0.5);
	sprite.texture = load(texture);
	#sprite.scale *= sprite_scale;
	self.type = GV.shallow_watters;
