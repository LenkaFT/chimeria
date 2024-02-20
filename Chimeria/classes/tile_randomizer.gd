class_name TileRandomizer

var temperate_weights = {
	GV.prairie : 35,
	GV.forest : 30,
	GV.highland : 15,
	GV.mountain : 10,
	GV.marsh : 10,
	"total" : 100
};
var hot_arid_weights = {
	GV.savannah : 35,
	GV.alluviale_plain : 0,
	GV.dryland : 30,
	GV.desert : 15,
	GV.mountain : 10,
	"total" : 100
};

var cold_arid_weights = {
	GV.steppe : 25,
	GV.taiga : 25,
	GV.highland : 15,
	GV.mountain : 10,
	"total" : 100
};

var equatorial_weights = {
	GV.jungle : 40,
	GV.tropical_highlands : 30,
	GV.marsh : 15,
	GV.moutain : 15,
	"total" : 100
};
var arctic_weights = {
	GV.ice_cap : 20,
	GV.arctic_mainland : 40,
	GV.arctic_mountain : 30,
	GV.toundra : 10,
	
	"total" : 100
};

#func balance_weights(tile : Tile, map : Map) :
	
