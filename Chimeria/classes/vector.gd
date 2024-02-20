class_name Vector

var _x : float;
var _y : float;
func _init(x : float, y : float) :
	_x = x;
	_y = y;
func dot(other : Vector) :
	return (_x * other._x + _y * other._y);
