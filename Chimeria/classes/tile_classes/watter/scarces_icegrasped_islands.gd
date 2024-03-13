class_name ScarcesIcegraspedIslandsTile extends Tile

var texture = "res://sqr/scarces_icegrasped_islands.png";
var category = "watter"
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
	self.type = GV.scarces_icegrasped_islands;
