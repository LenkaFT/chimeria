extends Node2D

var map : Map;
var weather_forecast : WeatherForcast;
# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_node("Map");
	weather_forecast = get_node("WeatherForecast");
	map.create_map();
	weather_forecast.create_heat_grid();
	weather_forecast.create_humidity_grid(map);
	map.rework_map_according_to_weather(weather_forecast.heat_grid, weather_forecast.humidity_grid);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
