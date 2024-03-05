class_name WeatherForcast
extends Node2D

var humidity_grid = [];
var heat_grid = [];
var width : int = GV.map_width;
var height : int = GV.map_height;
var permutation : Array[int];
var heat_overlay_requested : bool = false;
var humidity_overlay_requested : bool = false;
var perlin_square_frequency = 0.05;

func _init():
	pass ;
	
func create_heat_grid() :
	permutation = [];
	make_permutation();
	perlin_noise(heat_grid, "heat");

func create_humidity_grid() :
	permutation = [];
	make_permutation();
	perlin_noise(humidity_grid, "humidity");

func _draw():
	var rect_width = GV.tile_size; #* GV.sprite_scale;
	
	if heat_overlay_requested == true :
		for y in heat_grid.size() : 
			for x in heat_grid[y].size() :
				var rect = Rect2(x * rect_width, y * rect_width, rect_width, rect_width);
				var rgb = heat_grid[y][x];
				draw_rect(rect, Color(rgb, 0, 1 - rgb, 0.6), true);				
		heat_overlay_requested = false;
	
	if humidity_overlay_requested == true :
		for y in humidity_grid.size() : 
			for x in humidity_grid[y].size() :
				var rect = Rect2(x * rect_width, y * rect_width, rect_width, rect_width);
				var rgb = humidity_grid[y][x];
				draw_rect(rect, Color(1 - rgb, 1 - rgb, rgb, 0.6), true);
		humidity_overlay_requested = false;
			
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1:
			heat_overlay_requested = true;
			queue_redraw();
		if event.keycode == KEY_2:
			humidity_overlay_requested = true;
			queue_redraw();

func value_normalisation(value : float, min : float, max : float) -> float :
	return ((value - min) / (max - min));

func humidity_grid_normalisation(grid, min, max) :
	for y in height :
		for x in width :
			grid[y][x] = value_normalisation(grid[y][x], min, max);

func heat_grid_normalisation(grid, min, max) :
	for y in height :
		for x in width :
			grid[y][x] = value_normalisation(grid[y][x], min, max);
			if (y <= height / 2) :
				var tweaker = value_normalisation(y, 0, height / 2) / 2;
				grid[y][x] += (1 - grid[y][x]) * tweaker;
			else :
				var tweaker = (1.0 - value_normalisation(y, height / 2, height)) / 2;
				grid[y][x] += (1 - grid[y][x]) * tweaker;

func heat_map_value_tweak(y, value) :
	if (y <= height / 2) :
		return (value * value_normalisation(y, 0, height / 2));
	else :
		return (value * (1.0 - value_normalisation(y, height / 2, height)));

func perlin_noise(grid, grid_type : String) :
	var grid_min = 1;
	var grid_max = 0;
	var aspect_ratio = float(width) / float(height);
	var x_offset = Vector2(-1.0,1.0);
	var y_offset = 1 / aspect_ratio * Vector2(-1.0,1.0);
	
	for y in height :
		grid.append([]);
		for x in width :
			var value : float = noise_2d(x * perlin_square_frequency, y * perlin_square_frequency);
			value += 1.0;
			if grid_type == "heat" :
				value = heat_map_value_tweak(y, value);
			value /= 2.0;
			grid[y].append(value);
		
		if grid[y].min() < grid_min :
			grid_min = grid[y].min();
		if grid[y].max() > grid_max :
			grid_max = grid[y].max();
	
	if grid_type == "heat" :
		heat_grid_normalisation(grid, grid_min, grid_max);
	else :
		humidity_grid_normalisation(grid, grid_min, grid_max);

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
	var X1 : int = X + 1;
	var Y : int = floori(y) & 255;
	var xf = x - floor(x);
	var yf = y - floor(y);
	
	if x * 10 >= width - width * perlin_square_frequency :
		X1 = 0;
	
	var top_right = Vector.new(xf - 1.0, yf - 1.0);
	var top_left = Vector.new(xf, yf - 1.0);
	var bottom_right = Vector.new(xf - 1.0, yf);
	var bottom_left = Vector.new(xf, yf);
	
	var value_top_right = permutation[permutation[X1] + Y + 1];
	var value_top_left = permutation[permutation[X] + Y + 1];
	var value_bottom_right = permutation[permutation[X1] + Y];
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
