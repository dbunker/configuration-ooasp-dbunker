% Clothes example

% Classes
ooasp_class("v1", "Wardrobe").
ooasp_class("v1", "Top").
ooasp_class("v1", "Pants").
ooasp_class("v1", "Shirt").
ooasp_class("v1", "Shirtless").
ooasp_class("v1", "Jeans").
ooasp_class("v1", "Shoe").
ooasp_class("v1", "RightShoe").
ooasp_class("v1", "LeftShoe").


% Class inheritance
ooasp_subclass("v1", "Top", "Wardrobe").
ooasp_subclass("v1", "Pants", "Wardrobe").
ooasp_subclass("v1", "Shirt", "Top").
ooasp_subclass("v1", "Shirtless", "Top").
ooasp_subclass("v1", "Jeans", "Pants").
ooasp_subclass("v1", "Shoe", "Wardrobe").
ooasp_subclass("v1", "RightShoe", "Shoe").
ooasp_subclass("v1", "LeftShoe", "Shoe").


% Attributes and associations
ooasp_assoc("v1", "Wardrobe_right_shoe", "Wardrobe", 1, 1, "RightShoe", 1, 1).
ooasp_assoc("v1", "Wardrobe_left_shoe", "Wardrobe", 1, 1, "LeftShoe", 1, 1).
ooasp_assoc("v1", "Wardrobe_pants", "Wardrobe", 1, 1, "Pants", 1, 1).
ooasp_assoc("v1", "Wardrobe_top", "Wardrobe", 1, 1, "Top", 1, 1).

ooasp_attribute("v1", "Wardrobe", "need_top", "boolean").
ooasp_attribute("v1", "Wardrobe", "top_shade", "string").
ooasp_attribute("v1", "Wardrobe", "pants_shade", "string").
ooasp_attribute("v1", "Shoe", "size", "integer").

ooasp_attribute_minInclusive("v1", "Shoe", "size", 1).
ooasp_attribute_maxInclusive("v1", "Shoe", "size", 2).

ooasp_attribute_enum("v1", "Wardrobe", "top_shade", "Blue").
ooasp_attribute_enum("v1", "Wardrobe", "top_shade", "Grey").

ooasp_attribute_enum("v1", "Wardrobe", "pants_shade", "Blue").
ooasp_attribute_enum("v1", "Wardrobe", "pants_shade", "Grey").
