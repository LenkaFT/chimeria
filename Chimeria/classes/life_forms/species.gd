class_name Species;


var populations_chunks : Array = [];

@export var max_individus_per_chunk = 10000000; 
var ressources_consumption_per_tick : float;

## Gregariouness will affect how much individuals can be found in a population chunk and how many chunks of this species can gather on a tile before trouble happens; range : 0.0 to 1.0
var gregariousness : float = 0.0;

## will affect the fading over time of a chuck of population; range : 0.0 to 1.0
var life_expectancy : float = 0.0;

## size will affect how much individuals can be found in a population chunk and how many chunks of this species can gather on a tile before trouble happens, 
## bigger species will consumate ressources faster and will also be less plastic to biomes ; 
## range : 0.01 to 10 (meters) (refers to width or heigth depending on which is bigger, an American Aligator and a Elephant would be roughly the same size (approx 4m);
## will also affect predation, bugger species tend to have less predator and will have less
## will also affect spreading through sea capacity, large animal will never have the chance to cross large bodies of watter without specific amphibian adaptation, flights capacities or moving forward to tool crafting.
## minuscule : under 0.2 m,
## small : under 1.0 m,
## medium : under 2.0 m,
## large  : under 4.0 m,
## huge : under 8.0;
## cyclopean : over 8.0, most likely won't be a viable species.
var average_size : float = 0.0;

## roughly the same as size :
## range from 0.001kg to an 100 tons;
## very_light : under a kilo, can fit anywhere, adaptation and spreads champions (can fly), very fragile and must compensate by numbers;
## light : under 20kg (can fly); adaptable but fragile.
## medium : under 150kg, the most adaptable and resilient type; 
## big : under 500 kg, strong but consume more ressources.
## heavy : under 1500 kg, consume a lot of ressources. but way less prone to predation.
## super-heavy : under 5000 kg, consume a LOT of ressources. nearly never predated on except at a really young or a really late age.
## enourmous : under 10 000KG, need a huge vital space, tile will rarely support more than one chunk.
## Gargantuous : over 10 000 KG average, will only be viable in world where carbon levels allow for giant lifeforms. otherwise will die off due to starvation.
var average_weight : float = 0.0;

## how many offspring can an individual produce in on reproduction cycle; range from 1.0 
var fecondity : float = 1.0;

## Two possible types, SEXUAL or ASSEXUAL;
## sexual will make it harder to reproduce in low density area, but will make genome divergence more likely;
## assexual will not be affected by pop density but genomic divergence will be less likely;
var reproduction_type : String;

## Two possible types, QUALITATIVE or QUANTITATIVE;
## qualitative will produce few offspring with high chance of survival, slower but steadier and more durable expansion.
## quantitative produce lots of offspring at an exponantial pace, prone to overcrowding and wastefull expansion.
var reproduction_system : String;

## possibility are : 
## grazer (like cows, antilope, etc), will have a flatland bias;
## fruit_eater : will have a forest bias; most often of small to medium size.
## large_carnivore : will have a flat_land bias, where grazers lives;
## small_carnivore : very adaptables species that can find food pretty much anywhere. (include insectivores);
## omnivorous : very adaptable species of various sizes.
## scavanger : especialy resilient species that can live in very harsh environment, cannot be large or huge species.
var diet : String;

var can_fly : bool = false;

## range 0.0 to 1.0 -> at 0 (hippopotamus, giraffe, chimpanzee) the creature cannot swim, nearing 1 (seals, batracian) the creature can basically live in watter.
## a human would be a 0.25 a polar bear a 0.5 and a batracian a 1; 1 will never be able to stray that much from humid area and 0 will have a hard time migrating through watter.
var amphibian_capacity : float = 0.0;

## ranging from 0.0 to 1.0, those number will determine population attrition in certains biome and the capacities for the species to migrate to them
var climate_preference_dictionnary = {
		"humid" : 0.0,
		"arid" : 0.0,
		"hot" : 0.0,
		"cold" : 0.0,
		"polar" : 0.0
	}

func get_size_class() :
	if average_size < 0.2 :
		return (GV.minuscule);
	elif average_size < 1.0 :
		return (GV.small);
	elif average_size < 2.0 :
		return (GV.medium)
	elif average_size < 4.0 :
		return (GV.large);
	elif average_size < 8.0 :
		return (GV.huge);
	else :
		return (GV.cyclopean);
		

func get_weight_class() :
	if average_weight < 1.0 :
		return (GV.light);
	elif average_weight < 20.0 :
		return (GV.very_light);
	elif average_weight < 150.0 :
		return (GV.medium)
	elif average_weight < 500.0 :
		return (GV.big);
	elif average_weight < 1500.0 :
		return (GV.heavy);
	elif average_weight < 5000.0 :
		return (GV.super_heavy);
	elif average_weight < 10000.0 :
		return (GV.enormous);
	else :
		return (GV.gargantuous);
		
func calculate_ressource_consumption_per_tick() :
	var size_factor : float;
	var weight_factor : float;
	var diet_factor : float;
		

func _init() :
	gregariousness = 0.7;
	pass ;
