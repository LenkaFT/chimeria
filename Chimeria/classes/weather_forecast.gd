class_name WeatherForcast
extends Node2D

var humidity_grid = [];
var heat_grid = [];
var width : int = GV.map_width;
var height : int = GV.map_height;
var permutation : Array[int];
var overlay_requested : bool = false;

func _init():
	make_permutation();
	perlin_noise(humidity_grid);
	perlin_noise(heat_grid);

func _draw():
	var min = heat_grid[0].min();
	var max = heat_grid[0].max();
	if overlay_requested == true :
		var rect_width = GV.tile_size * GV.sprite_scale;
		for y in heat_grid.size() : 
			if min > heat_grid[y].min() :
				min = heat_grid[y].min();
			if max < heat_grid[y].max() :
				max = heat_grid[y].max();
			for x in heat_grid[y].size() :
				var rect = Rect2(x * rect_width, y * rect_width, rect_width, rect_width);
				var rgb = heat_grid[y][x];
				draw_rect(rect, Color(rgb, 0, 1 - rgb, 0.6), true);				
		overlay_requested = false;
		print("min : ", min, " | max : ", max);
			
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_0:
			overlay_requested = true;
			queue_redraw();

func perlin_noise(grid) :
	for y in height :
		grid.append([]);
		for x in width :
			#print("x and y before : ", x, " | ", y);
			var n : float = noise_2d(x * 0.01, y * 0.05);
			n += 1.0;
			n /= 2.0;
			
			#print("n : ", n);
			var value = n;
			#print("value : ", value);
			grid[y].append(value);

func make_permutation() :
	for n in 256 :
		permutation.append(n);
	permutation.shuffle();
	for n in 256 :
		permutation.append(permutation[n]);

func get_constant_vector(value : int) :
	var vector_direction = value & 3;
	if vector_direction == 0 :
		return Vector.new(1.0, 1.0)
	elif vector_direction == 1 :
		return Vector.new(-1.0, 1.0)
	elif vector_direction == 2 :
		return Vector.new(-1.0, 1.0)
	else :
		return Vector.new(1.0, -1.0)

func perlin_fade(interpolation_value) :
	return (((6 * interpolation_value - 15) * interpolation_value + 10) * 
	interpolation_value * interpolation_value * interpolation_value);

func linear_interpolation(interpolation_value, v1, v2) :
	return (v1 + interpolation_value * (v2 - v1));

func noise_2d(x : float, y : float) :
	var X : int = floori(x) & 255;
	var Y : int = floori(y) & 255;
	var xf = x - floor(x);
	var yf = y - floor(y);
	
	#print(x, " | ", y, " | ",X , " | ", Y, " | ", xf, " | ", yf);
	
	var top_right = Vector.new(xf - 1.0, yf - 1.0);
	var top_left = Vector.new(xf, yf - 1.0);
	var bottom_right = Vector.new(xf - 1.0, yf);
	var bottom_left = Vector.new(xf, yf);
	
	var value_top_right = permutation[permutation[X + 1] + Y + 1];
	var value_top_left = permutation[permutation[X] + Y + 1];
	var value_bottom_right = permutation[permutation[X + 1] + Y];
	var value_bottom_left = permutation[permutation[X] + Y];
	
	var dot_top_right = top_right.dot(get_constant_vector(value_top_right));
	var dot_top_left = top_left.dot(get_constant_vector(value_top_left));
	var dot_bottom_right = bottom_right.dot(get_constant_vector(value_bottom_right));
	var dot_bottom_left = bottom_left.dot(get_constant_vector(value_bottom_left));
	
	var xf_interpol_value = perlin_fade(xf);
	var yf_interpol_value = perlin_fade(yf);
	
	return(linear_interpolation(xf_interpol_value,
	linear_interpolation(yf_interpol_value, dot_bottom_left, dot_top_left),
	linear_interpolation(yf_interpol_value, dot_bottom_right, dot_top_right)
	));
