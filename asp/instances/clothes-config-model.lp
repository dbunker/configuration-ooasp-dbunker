% Clothes example

% Classes
ooasp_class("v1", "Clothes").
ooasp_class("v1", "Attire").
ooasp_class("v1", "Top").
ooasp_class("v1", "Pants").
ooasp_class("v1", "Shirt").
ooasp_class("v1", "Flannel").
ooasp_class("v1", "Jeans").
ooasp_class("v1", "Shoe").
ooasp_class("v1", "RightShoe").
ooasp_class("v1", "LeftShoe").


% Class inheritance
ooasp_subclass("v1", "Attire", "Clothes").
ooasp_subclass("v1", "Top", "Clothes").
ooasp_subclass("v1", "Pants", "Clothes").
ooasp_subclass("v1", "Shoe", "Clothes").
ooasp_subclass("v1", "Shirt", "Top").
ooasp_subclass("v1", "Flannel", "Top").
ooasp_subclass("v1", "Jeans", "Pants").
ooasp_subclass("v1", "Shoe", "Clothes").
ooasp_subclass("v1", "RightShoe", "Shoe").
ooasp_subclass("v1", "LeftShoe", "Shoe").


% Attributes and associations
ooasp_assoc("v1", "Attire_pants", "Attire", 1, 1, "Pants", 1, 1).
ooasp_assoc("v1", "Attire_top", "Attire", 1, 1, "Top", 1, 1).
ooasp_assoc("v1", "Attire_right_shoe", "Attire", 1, 1, "RightShoe", 1, 1).
ooasp_assoc("v1", "Attire_left_shoe", "Attire", 1, 1, "LeftShoe", 1, 1).

ooasp_attribute("v1", "Attire", "cold_out", "boolean").
ooasp_attribute("v1", "Attire", "top_shade", "string").
ooasp_attribute("v1", "Attire", "pants_shade", "string").
ooasp_attribute("v1", "Shoe", "shoe_size", "integer").

ooasp_attribute_minInclusive("v1", "Shoe", "shoe_size", 1).
ooasp_attribute_maxInclusive("v1", "Shoe", "shoe_size", 2).

ooasp_attribute_enum("v1", "Attire", "top_shade", "Blue").
ooasp_attribute_enum("v1", "Attire", "top_shade", "Grey").

ooasp_attribute_enum("v1", "Attire", "pants_shade", "Blue").
ooasp_attribute_enum("v1", "Attire", "pants_shade", "Grey").
