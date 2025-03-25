#include "./ooasp.lp".

% Domain specific constraints

% Ex. ooasp_attribute_value("c1", "wheel_size", ("WheelBack", 1), 14)
% Ex. ooasp_attribute_value("c1", "child_model", ("Frame", 1), "TRUE")
% Ex. ooasp_attribute_value("c1", "gears", ("Frame", 1), "Hub")
% Ex. ooasp_associated("c1", "Frame_wheel_back", ("Frame", 1), ("WheelBack", 1))

% The front and back wheels associated with a frame must be of the
% same size.
:-  ooasp_instantiation("v1", I),
    ooasp_attribute_value(I, "wheel_size", ("WheelBack", BACK_O), BACK_VAL),
    ooasp_attribute_value(I, "wheel_size", ("WheelFront", FRONT_O), FRONT_VAL),
    ooasp_associated(I, "Frame_wheel_back", ("Frame", FRAME_O), ("WheelBack", BACK_O)),
    ooasp_associated(I, "Frame_wheel_front", ("Frame", FRAME_O), ("WheelFront", FRONT_O)),
    BACK_VAL != FRONT_VAL.

% If child_model is selected for a frame, both wheels associated with
% said frame cannot be larger than 16.
:-  ooasp_instantiation("v1", I),
    ooasp_attribute_value(I, "wheel_size", ("WheelBack", BACK_O), BACK_VAL),
    ooasp_attribute_value(I, "child_model", ("Frame", FRAME_O), "TRUE"),
    ooasp_associated(I, "Frame_wheel_back", ("Frame", FRAME_O), ("WheelBack", BACK_O)),
    BACK_VAL > 16.

% If child_model is selected for a frame, the selected gears for said
% frame must be derailleur.
:-  ooasp_instantiation("v1", I),
    ooasp_attribute_value(I, "child_model", ("Frame", FRAME_O), "TRUE"),
    not ooasp_attribute_value(I, "gears", ("Frame", FRAME_O), "Derailleur").
