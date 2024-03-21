extends Node

var tiles_types : Array = ["prairie", "forest", "mountain", "desert", "sea"];
var direction_array :Array = ["North", "South", "East", "West"]
var tile_size = 64;
var sprite_scale = 0.25;
var map_width = 100;
var map_height = 80;


var prairie = "prairie"; ##
var marsh = "marsh";
var forest = "forest";

var highland = "highland";
var wooded_highland = "wooded_highland";
var mountain = "mountain";
var wooded_mountain = "wooded_mountain";
var snowy_mountains = "snowy_mountains";

var desert = "desert";
var savannah = "savannah";
var dryland = "dryland";
var alluviale_plain = "alluviale_plain";

var jungle = "jungle";
var tropical_highlands = "tropical_highlands";

var taiga = "taiga";
var steppe = "steppe";

var toundra = "toundra";
var ice_cap = "ice_cap";
var arctic_mainland = "arctic_mainland";

var scarces_rocky_islands = "scarces_rocky_islands";
var scarces_luxurious_islands = "scarces_luxurious_islands";
var scarces_icegrasped_islands = "scarces_icegrasped_islands";
var shallow_watters = "shallow_watters";
var sea = "sea";

var minuscule = "minuscule";
var small = "small";
var medium = "medium";
var larg = "larg";
var huge = "huge";
var cyclopean = "cyclopean";

var light = "light";
var very_light = "very_light";
var big = "big";
var heavy = "heavy";
var super_heavy = "super_heavy";
var enourmous = "enormous";
var gargantuous = "gargantuous";

var HALF_PI = PI * 0.5;
var ONE_AND_HALF_PI = PI * 1.5;
var TWO_PI = PI * 2;

var carbon_levels = 1;
var vegetal_to_animal_biomass_ratio = 0.005;
var vegetal_to_animal_biomass_in_ocean_ratio = 3;
