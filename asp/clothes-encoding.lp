#include "./ooasp.lp".

% Domain specific constraints

% Shoes must be same size for wardrobe
:-  ooasp_instantiation("v1", I),
    ooasp_attribute_value(I, "shoe_size", ("RightShoe", RIGHT_O), RIGHT_VAL),
    ooasp_attribute_value(I, "shoe_size", ("LeftShoe", LEFT_O), LEFT_VAL),
    ooasp_associated(I, "Attire_right_shoe", ("Attire", ATTIRE_O), ("RightShoe", RIGHT_O)),
    ooasp_associated(I, "Attire_left_shoe", ("Attire", ATTIRE_O), ("LeftShoe", LEFT_O)),
    RIGHT_VAL != LEFT_VAL.

% Top shade must match pants shade for wardrobe
:-  ooasp_instantiation("v1", I),
    ooasp_attribute_value(I, "pants_shade", ("Attire", ATTIRE_O), SHADE),
    not ooasp_attribute_value(I, "top_shade", ("Attire", ATTIRE_O), SHADE).

% If cold out, shirt is not alowed for wardrobe
:-  ooasp_instantiation("v1", I),
    ooasp_attribute_value(I, "cold_out", ("Attire", ATTIRE_O), "TRUE"),
    ooasp_associated(I, "Attire_top", ("Attire", ATTIRE_O), ("Shirt", _)).
