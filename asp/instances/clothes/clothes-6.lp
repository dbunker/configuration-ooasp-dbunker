#include "../clothes-config-model.lp".

partial(ooasp_instantiation("v1", "c1")).
partial(ooasp_isa("c1", "Attire", ("Attire", 1))).
partial(ooasp_attribute_value("c1", "cold_out", ("Attire", 1), "TRUE")).
partial(ooasp_attribute_value("c1", "pants_shade", ("Attire", 1), "Grey")).

% Unsatisfiable
partial(ooasp_associated("c1", "Attire_top", ("Attire", 1), ("Shirt", 1))).
partial(ooasp_isa("c1", "Shirt", ("Shirt", 1))).
