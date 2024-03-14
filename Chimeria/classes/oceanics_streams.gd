class_name OceanicsStreams
extends Node2D

var humidity_map;
var heat_map;
var streams_grid = [];
var requested_streams_overlay : bool;
var camera : Camera2D;

func _init() :
	pass ;

func get_coldest_neighbour(tile : Tile, grid) -> String :
	var north_tile = tile.getNorthTile(grid);
	var south_tile = tile.getSouthTile(grid);
	var east_tile = tile.getEastTile(grid);
	var west_tile = tile.getWestTile(grid);
	var temperature = 1;
	var coldest_tile : String;
	
	if north_tile != null :
		temperature = heat_map[north_tile.y][north_tile.x]
		coldest_tile = "north_tile";
	if south_tile != null && heat_map[south_tile.y][south_tile.x] <= temperature :
		temperature = heat_map[south_tile.y][south_tile.x]
		coldest_tile = "south_tile";
	if east_tile != null && heat_map[east_tile.y][east_tile.x] <= temperature :
		temperature = heat_map[east_tile.y][east_tile.x]
		coldest_tile = "east_tile";
	if west_tile != null && heat_map[west_tile.y][west_tile.x] <= temperature :
		temperature = heat_map[west_tile.y][west_tile.x]
		coldest_tile = "west_tile";
	return (coldest_tile);

func go_toward_biggest_temperature_differential(tile : Tile, grid) :
	var north_tile = tile.getNorthTile(grid);
	var south_tile = tile.getSouthTile(grid);
	var east_tile = tile.getEastTile(grid);
	var west_tile = tile.getWestTile(grid);
	var temperature_differential = 0;
	var coldest_tile : String;
	
	if north_tile != null && tile.stream_force >= north_tile.stream_force:
		temperature_differential = (heat_map[north_tile.y][north_tile.x] - heat_map[tile.y][tile.x])
		coldest_tile = "north_tile";
	if south_tile != null &&  (heat_map[south_tile.y][south_tile.x] - heat_map[tile.y][tile.x]) > temperature_differential && tile.stream_force >= south_tile.stream_force:
		temperature_differential = (heat_map[south_tile.y][south_tile.x] - heat_map[tile.y][tile.x]);
		coldest_tile = "south_tile";
	if east_tile != null && (heat_map[east_tile.y][east_tile.x] - heat_map[tile.y][tile.x]) > temperature_differential && tile.stream_force >= east_tile.stream_force:
		temperature_differential = (heat_map[east_tile.y][east_tile.x] - heat_map[tile.y][tile.x]);
		coldest_tile = "east_tile";
	if west_tile != null && (heat_map[west_tile.y][west_tile.x] - heat_map[tile.y][tile.x]) > temperature_differential && tile.stream_force >= west_tile.stream_force:
		temperature_differential = (heat_map[west_tile.y][west_tile.x] - heat_map[tile.y][tile.x]);
		coldest_tile = "west_tile";
	return (coldest_tile);
	
#func get_second_hottest_neighbour(tile : Tile, grid) :
	#var north_tile : Tile = tile.getNorthTile(grid);
	#var south_tile : Tile = tile.getSouthTile(grid);
	#var east_tile : Tile = tile.getEastTile(grid);
	#var west_tile : Tile = tile.getWestTile(grid);
	#var north_temp : float;
	#var south_temp : float;
	#var east_temp : float;
	#var west_temp : float;
	#var temperature_array : Array = [];
	#
	#if north_tile != null :
		#temperature_array.append(north_temp)
		#north_temp = heat_map[north_tile.y][north_tile.x];
	#else :
		#temperature_array.append(0);
	#if south_tile != null:
		#south_temp = heat_map[south_tile.y][south_tile.x]
		#temperature_array.append(south_temp)
	#else :
		#temperature_array.append(0);
	#if east_tile != null:
		#east_temp = heat_map[east_tile.y][east_tile.x]
		#temperature_array.append(east_temp)
	#else :
		#temperature_array.append(0);
	#if west_tile != null:
		#west_temp = heat_map[west_tile.y][west_tile.x]
		#temperature_array.append(west_temp)
	#else :
		#temperature_array.append(0);
	#temperature_array.sort();
#
	#var second_hottest = temperature_array[temperature_array.size() - 2];
	#match second_hottest :
		#north_temp : 
			#return("north_tile");
		#south_temp : 
			#return("south_tile");
		#east_temp :
			#return("east_tile");
		#west_temp :
			#return("west_tile");
		#_:
			#return("north_tile");

func determine_stream_force() :
	for y in streams_grid.size() :
		for x in streams_grid[y].size() :
			if streams_grid[y][x] != null :
				if streams_grid[y][x].getNorthTile(streams_grid) == null:
					streams_grid[y][x].stream_force -= 0.25;
				if streams_grid[y][x].getSouthTile(streams_grid) == null :
					streams_grid[y][x].stream_force -= 0.25;
				if streams_grid[y][x].getEastTile(streams_grid) == null:
					streams_grid[y][x].stream_force -= 0.25;
				if streams_grid[y][x].getWestTile(streams_grid) == null :
					streams_grid[y][x].stream_force -= 0.25;
					
	for y in streams_grid.size() :
		for x in streams_grid[y].size() :
			if streams_grid[y][x] != null && streams_grid[y][x].stream_force == 1.0:
				if streams_grid[y][x].getNorthTile(streams_grid).stream_force <= 1.0:
					streams_grid[y][x].stream_force = (streams_grid[y][x].stream_force + streams_grid[y][x].getNorthTile(streams_grid).stream_force) * 0.5;
				if streams_grid[y][x].getSouthTile(streams_grid).stream_force <= 1.0:
					streams_grid[y][x].stream_force = (streams_grid[y][x].stream_force + streams_grid[y][x].getSouthTile(streams_grid).stream_force) * 0.5;
				if streams_grid[y][x].getEastTile(streams_grid).stream_force <= 1.0:
					streams_grid[y][x].stream_force =(streams_grid[y][x].stream_force + streams_grid[y][x].getEastTile(streams_grid).stream_force) * 0.5;
				if streams_grid[y][x].getWestTile(streams_grid).stream_force <= 1.0 :
					streams_grid[y][x].stream_force = (streams_grid[y][x].stream_force + streams_grid[y][x].getWestTile(streams_grid).stream_force) * 0.5;

func determine_watter_flow() :
	var dist_to_equ : float ;
	var coldest_neighbour : String;
	var second_hottest_neighbour : String;
	
	for y in streams_grid.size() :
		for x in streams_grid[y].size() :
			#if streams_grid[y][x] != null && heat_map[y][x] <= 0.25 :
				#second_hottest_neighbour = get_second_hottest_neighbour(streams_grid[y][x], streams_grid);
				#if second_hottest_neighbour == "north_tile" :
					#streams_grid[y][x].stream_direction = PI + heat_map[y][x] * PI;
				#elif second_hottest_neighbour == "south_tile" :
					#streams_grid[y][x].stream_direction = heat_map[y][x] * PI;
				#elif second_hottest_neighbour == "east_tile" :
					#streams_grid[y][x].stream_direction = (1.5 * PI) + heat_map[y][x] * PI;
					#if streams_grid[y][x].stream_direction > 2 * PI :
						#streams_grid[y][x].stream_direction -= 2 * PI;
				#elif second_hottest_neighbour == "west_tile" :
					#streams_grid[y][x].stream_direction = (0.5 * PI) + heat_map[y][x] * PI;
				#if stream_goes_opposite_way(streams_grid[y][x], second_hottest_neighbour) == true:
					#streams_grid[y][x].stream_direction = abs(2 * PI - streams_grid[y][x].stream_direction)
					
			if streams_grid[y][x] != null :
				coldest_neighbour = go_toward_biggest_temperature_differential(streams_grid[y][x], streams_grid);
				if coldest_neighbour == "north_tile" :
					streams_grid[y][x].stream_direction = PI + heat_map[y][x] * PI;
				elif coldest_neighbour == "south_tile" :
					streams_grid[y][x].stream_direction = heat_map[y][x] * PI;
				elif coldest_neighbour == "east_tile" :
					streams_grid[y][x].stream_direction = (1.5 * PI) + heat_map[y][x] * PI;
					if streams_grid[y][x].stream_direction > 2 * PI :
						streams_grid[y][x].stream_direction -= 2 * PI;
				elif coldest_neighbour == "west_tile" :
					streams_grid[y][x].stream_direction = (0.5 * PI) + heat_map[y][x] * PI;
					
				#if streams_grid[y][x].stream_direction == 0 || streams_grid[y][x].stream_direction == 1 :
					

func make_streams(map : Map) :
	for y in map.grid.size():
		streams_grid.append([]);
		for x in map.grid[y].size() :
			if map.grid[y][x].category == "watter" :
				streams_grid[y].append(map.grid[y][x]);
			else :
				streams_grid[y].append(null);
	
	humidity_map = map.humidity_grid;
	heat_map = map.heat_grid;
	
	determine_stream_force();
	determine_watter_flow();

func draw_streams() :
	var visible_tiles_in_pov_x: int = 0;
	var visible_tiles_in_pov_y : int = 0;
	var top_left_x : int = 0;
	var top_left_y : int = 0;
	var y : int = 0;
	var x : int = 0;
	var it_count : int = 0;
	var x_index : int;
	var rgb;
	var triangle_center : Vector2;
	var radius = GV.tile_size / 4;
	var radius_x_force ;
	var cornerA : Vector2;
	var cornerB : Vector2;
	var cornerC : Vector2;
	var triangle;
	
	if camera :
		visible_tiles_in_pov_x = ceil(camera.get_viewport_rect().size.x / (camera.zoom.x * GV.tile_size));
		visible_tiles_in_pov_y = ceil(camera.get_viewport_rect().size.y / (camera.zoom.y * GV.tile_size));
		top_left_x = floor(camera.global_position.x / GV.tile_size);
		top_left_y = floor(camera.global_position.y / GV.tile_size);
		y = top_left_y;
		x = top_left_x;
	
	while y <= top_left_y + visible_tiles_in_pov_y and y < GV.map_height : 
		x = top_left_x;
		it_count = 0;
		while x < 0 && it_count <= visible_tiles_in_pov_x:
			x_index = GV.map_width - x % GV.map_width * -1;
			if x_index == GV.map_width :
				x_index = 0;
			## 
			if streams_grid[y][x_index] != null :
				rgb = heat_map[y][x_index];
				radius_x_force = radius * streams_grid[y][x_index].stream_force;
				triangle_center = Vector2(streams_grid[y][x_index].sprite.position.x, y * GV.tile_size + GV.tile_size * 0.5)
				cornerA = triangle_center + Vector2(radius_x_force * cos(streams_grid[y][x_index].stream_direction), radius_x_force * sin(streams_grid[y][x_index].stream_direction));
				cornerB = triangle_center + Vector2(radius_x_force * cos(streams_grid[y][x_index].stream_direction - 0.75 * PI), radius_x_force * sin(streams_grid[y][x_index].stream_direction - 0.75 * PI));
				cornerC = triangle_center + Vector2(radius_x_force * cos(streams_grid[y][x_index].stream_direction + 0.75 * PI), radius_x_force * sin(streams_grid[y][x_index].stream_direction +  0.75 * PI));
				triangle = PackedVector2Array([cornerA, cornerB, cornerC, cornerA]);
				draw_polyline(triangle, Color(rgb, 0, 1 - rgb, 0.6), 6, true);
			## 
			x += 1;
			it_count += 1;
		while x >= 0 && it_count <= visible_tiles_in_pov_x :
			x_index = x % GV.map_width ;
			## 
			if streams_grid[y][x_index] != null :
				rgb = heat_map[y][x_index];
				radius_x_force = radius * streams_grid[y][x_index].stream_force;
				triangle_center = Vector2(streams_grid[y][x_index].sprite.position.x, y * GV.tile_size + GV.tile_size * 0.5);
				cornerA = triangle_center + Vector2(radius_x_force * cos(streams_grid[y][x_index].stream_direction), radius_x_force * sin(streams_grid[y][x_index].stream_direction));
				cornerB = triangle_center + Vector2(radius_x_force * cos(streams_grid[y][x_index].stream_direction - 0.75 * PI), radius_x_force * sin(streams_grid[y][x_index].stream_direction - 0.75 * PI));
				cornerC = triangle_center + Vector2(radius_x_force * cos(streams_grid[y][x_index].stream_direction + 0.75 * PI), radius_x_force * sin(streams_grid[y][x_index].stream_direction +  0.75 * PI));
				triangle = PackedVector2Array([cornerA, cornerB, cornerC, cornerA]);
				draw_polyline(triangle, Color(rgb, 0, 1 - rgb, 0.6), 6, true);
			## 
			x += 1;
			it_count += 1;
		y += 1;

func _draw() :
	if requested_streams_overlay == true :
		draw_streams();
		requested_streams_overlay = false;
		
func draw_streams_overlay(cam : Camera2D) :
	camera = cam;
	requested_streams_overlay = true;
	queue_redraw();
