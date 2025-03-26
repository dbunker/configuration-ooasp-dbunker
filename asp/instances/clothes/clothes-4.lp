#include "../clothes-config-model.lp".

partial(ooasp_instantiation("v1", "c1")).
partial(ooasp_isa("c1", "Attire", ("Attire", 1))).
partial(ooasp_isa("c1", "Attire", ("LeftShoe", 1))).
partial(ooasp_attribute_value("c1", "cold_out", ("Attire", 1), "FALSE")).
partial(ooasp_attribute_value("c1", "pants_shade", ("Attire", 1), "Grey")).
partial(ooasp_associated("c1", "Attire_left_shoe", ("Attire", 1), ("LeftShoe", 1))).
