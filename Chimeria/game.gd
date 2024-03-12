extends Node2D

var map : Map;
var weather_forecast : WeatherForcast;
var camera : Camera2D;

@export var max_zoom = 2;
@export var min_zoom = 0.5;
@export var zoom_intensity = 1.1;

var humidity_overlay_on : bool = false;
var heat_overlay_on : bool = false;
var directions = {"UP" : false, "DOWN" : false, "LEFT" : false, "RIGHT" : false};
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("Camera2D");
	camera.set_anchor_mode(0);
	camera.set_limit(SIDE_TOP, 0)
	camera.set_limit(SIDE_BOTTOM, GV.map_height * GV.tile_size)
	map = get_node("Map");
	weather_forecast = get_node("WeatherForecast");
	weather_forecast.create_heat_grid();
	weather_forecast.create_humidity_grid();
	map.create_map(weather_forecast.heat_grid, weather_forecast.humidity_grid);
	var visible_tiles_in_pov_x = camera.get_viewport_rect().size.x / (camera.zoom.x * GV.tile_size)
	var visible_tiles_in_pov_y = camera.get_viewport_rect().size.y / (camera.zoom.y * GV.tile_size)
	map.display_map(camera.global_position.x, camera.global_position.y, visible_tiles_in_pov_x, visible_tiles_in_pov_y)

func move_down(delta) :
	var camera_treshold = camera.limit_bottom - (camera.get_viewport_rect().size.y / (camera.zoom.y * GV.tile_size) * GV.tile_size);
	if camera.global_position.y + GV.tile_size <= camera_treshold:
		camera.global_position += Vector2.DOWN * (GV.tile_size);
	elif camera.global_position.y + GV.tile_size - camera_treshold < GV.tile_size :
		camera.global_position += Vector2.DOWN * (camera.global_position.y + GV.tile_size - camera_treshold);
		
func move_up(delta) :
	if camera.global_position.y - GV.tile_size >= camera.limit_top:
		camera.global_position += Vector2.UP * (GV.tile_size);
	elif camera.global_position.y - GV.tile_size >= camera.limit_top - GV.tile_size:
		camera.global_position += Vector2.UP * ((camera.global_position.y - GV.tile_size) * -1);

func move_left(delta) :
	camera.global_position += Vector2.LEFT * (GV.tile_size);
	
func move_right(delta) :
	camera.global_position += Vector2.RIGHT * (GV.tile_size);
	
func zoom_in(point) :
	var new_zoom = camera.zoom * 1.1;
	var new_pos;
	var camera_treshold = camera.limit_bottom - (camera.get_viewport_rect().size.y / (new_zoom.y * GV.tile_size) * GV.tile_size);
	
	if new_zoom.x > max_zoom || new_zoom.y > max_zoom:
		return;
	new_pos = camera.global_position - (point / new_zoom - point / camera.zoom );
	if new_pos.y < 0 :
		new_pos.y = 0;
	elif new_pos.y > camera_treshold :
		new_pos.y = camera_treshold;
	camera.global_position = new_pos;
	camera.set_zoom(camera.zoom * zoom_intensity);

func zoom_out(point) :
	var new_zoom = camera.zoom / zoom_intensity;
	var new_pos;
	var camera_treshold = camera.limit_bottom - (camera.get_viewport_rect().size.y / (new_zoom.y * GV.tile_size) * GV.tile_size);	
	
	if (GV.map_height * (GV.tile_size * new_zoom.y) < camera.get_viewport_rect().size.y ||
	GV.map_width * (GV.tile_size * new_zoom.x) < camera.get_viewport_rect().size.x) :
		return ;
	new_pos = camera.global_position - (point / new_zoom - point / camera.zoom );
	
	if new_pos.y < 0 :
		new_pos.y = 0;
	elif new_pos.y > camera_treshold:
		new_pos.y = camera_treshold - (point.y / new_zoom.y - point.y / camera.zoom.y );
	
	camera.global_position = new_pos;
	camera.set_zoom(new_zoom);

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit();
		elif event.keycode == KEY_A:
			directions["LEFT"] = true;
		elif event.keycode == KEY_D:
			directions["RIGHT"] = true;
		elif event.keycode == KEY_W :
			directions["UP"] = true;
		elif event.keycode == KEY_S :
			directions["DOWN"] = true;
		elif event.keycode == KEY_1 && heat_overlay_on == false:
			heat_overlay_on = true;
		elif event.keycode == KEY_2 && humidity_overlay_on == false:
			humidity_overlay_on = true;
		else :
			heat_overlay_on = false;
			humidity_overlay_on = false;
	
	if event is InputEventKey and event.is_released() :
		if event.keycode == KEY_A:
			directions["LEFT"] = false;
		elif event.keycode == KEY_D:
			directions["RIGHT"] = false;
		elif event.keycode == KEY_W :
			directions["UP"] = false;
		elif event.keycode == KEY_S :
			directions["DOWN"] = false;
		

	elif event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed :
			zoom_out(event.position)
			
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_in(event.position);
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if heat_overlay_on == true :
		weather_forecast.draw_heat_map(camera);
	elif humidity_overlay_on == true :
		weather_forecast.draw_humidity_map(camera);
	else :
		weather_forecast.remove_overlay();
	
	if directions["UP"] :
		move_up(delta);
	if directions["DOWN"] :
		move_down(delta);
	if directions["LEFT"] :
		move_left(delta);
	if directions["RIGHT"] :
		move_right(delta);
		
	var visible_tiles_in_pov_x = ceil(camera.get_viewport_rect().size.x / (camera.zoom.x * GV.tile_size));
	var visible_tiles_in_pov_y = ceil(camera.get_viewport_rect().size.y / (camera.zoom.y * GV.tile_size));
	map.display_map(camera.global_position.x, camera.global_position.y, visible_tiles_in_pov_x, visible_tiles_in_pov_y);
	
