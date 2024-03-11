extends Node2D

var map : Map;
var weather_forecast : WeatherForcast;
var camera : Camera2D;

@export var max_zoom = 2;
@export var min_zoom = 0.5;
@export var zoom_intensity = 1.1;
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

func move_down() :
	var camera_treshold = camera.limit_bottom - (camera.get_viewport_rect().size.y / (camera.zoom.y * GV.tile_size) * GV.tile_size);
	if camera.global_position.y + GV.tile_size <= camera_treshold:
		camera.global_position += Vector2.DOWN * (GV.tile_size);
	elif camera.global_position.y + GV.tile_size - camera_treshold < GV.tile_size :
		camera.global_position += Vector2.DOWN * (camera.global_position.y + GV.tile_size - camera_treshold);
		
func move_up() :
	if camera.global_position.y - GV.tile_size >= camera.limit_top:
		camera.global_position += Vector2.UP * (GV.tile_size);
	elif camera.global_position.y - GV.tile_size >= camera.limit_top - GV.tile_size:
		camera.global_position += Vector2.UP * ((camera.global_position.y - GV.tile_size) * -1);

func move_left() :
	pass ;
	
func move_right() :
	pass ;
	
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
			camera.global_position += Vector2.LEFT * (GV.tile_size);
			move_left();
		elif event.keycode == KEY_D:
			camera.global_position += Vector2.RIGHT * (GV.tile_size);
		elif event.keycode == KEY_W :
			move_up();
		elif event.keycode == KEY_S :
			move_down();

	elif event is InputEventMouseButton :
		#print("mouse pos : ", event.position)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed :
			#if (camera.global_position.y + camera.get_viewport_rect().size.y) / GV.tile_size > GV.map_height / 2 :
				#camera.drag_vertical_offset = -1;
			#else :
				#camera.drag_vertical_offset = 1;
			zoom_out(event.position)
			
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_in(event.position);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var visible_tiles_in_pov_x = camera.get_viewport_rect().size.x / (camera.zoom.x * GV.tile_size);
	var visible_tiles_in_pov_y = camera.get_viewport_rect().size.y / (camera.zoom.y * GV.tile_size);
	map.display_map(camera.global_position.x, camera.global_position.y, visible_tiles_in_pov_x, visible_tiles_in_pov_y);

	pass
