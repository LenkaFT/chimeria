class_name  SpeciesChunk;

var max_individuals_per_chunk : float;
var individuals_in_chunk : int;
var ressources_comsomption_per_tick : float;
var juvenile_proportion : float;
var of_procreation_age_proportion : float;
var species : Species;

func _init(chunk_species : Species, base_pop : float) :
	self.species = chunk_species;
	individuals_in_chunk = floor(base_pop); 
	calcultate_max_individuals_per_chunk(self.species.gregariousness);
	
func calcultate_max_individuals_per_chunk(gregariousness : float) :
	var exponant = log(10000000)
	var natural_logarithm = 2.718281828459;
	print(exponant);
	
	self.max_individuals_per_chunk = floor(pow(pow(natural_logarithm, exponant), gregariousness));
	print(self.max_individuals_per_chunk)
