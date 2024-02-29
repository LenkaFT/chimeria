extends Node2D

var map : Map;
var weather_forecast : WeatherForcast;
var camera : Camera2D;
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("Camera2D")
	map = get_node("Map");
	weather_forecast = get_node("WeatherForecast");
	weather_forecast.create_heat_grid();
	weather_forecast.create_humidity_grid(map);
	map.create_map(weather_forecast.heat_grid, weather_forecast.humidity_grid);

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_A:
			camera.global_position += Vector2.LEFT * 100;
		if event.keycode == KEY_D:
			camera.global_position += Vector2.RIGHT * 100;
		if event.keycode == KEY_W:
			camera.global_position += Vector2.UP * 100;
		if event.keycode == KEY_S:
			camera.global_position += Vector2.DOWN * 100;
		if event.keycode == KEY_E :
			camera.set_zoom(camera.zoom * Vector2(1.1, 1.1));
			print("Zoom : ", camera.zoom);
		if event.keycode == KEY_Q :
			camera.set_zoom(camera.zoom * Vector2(0.9,0.9));
			print("Zoom : ", camera.zoom);

	elif event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed :
			camera.set_zoom(camera.zoom * Vector2(0.9,0.9));
			print("down")
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			camera.set_zoom(camera.zoom * Vector2(1.1, 1.1));
			print("up")
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
