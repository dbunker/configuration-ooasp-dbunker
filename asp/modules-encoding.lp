#include "./ooasp.lp".

% Domain specific constraints

% Ex. ooasp_attribute_value("c1", "position", ("ModuleA", 1), 1)
% Ex. ooasp_associated("c1", "Frame_modules", ("Frame", 1), ("ModuleA", 1))

% Two modules in the same frame cannot have the same position
:-  ooasp_instantiation("v1", I),
    ooasp_attribute_value(I, "position", (CS1, OS1), VAL_A),
    ooasp_attribute_value(I, "position", (CS2, OS2), VAL_B),
	ooasp_full_isa(I, "Module", (CS1, OS1)),
    ooasp_full_isa(I, "Module", (CS2, OS2)),
    (CS1, OS1) != (CS2, OS2),
    ooasp_associated(I, "Frame_modules", ("Frame", F_OS), (CS1, OS1)),
    ooasp_associated(I, "Frame_modules", ("Frame", F_OS), (CS2, OS2)),
	VAL_A == VAL_B.

% Two modules of type ModuleA may not be adjacent to each other
:-  ooasp_instantiation("v1", I),
    ooasp_attribute_value(I, "position", ("ModuleA", OS1), VAL_A),
    ooasp_attribute_value(I, "position", ("ModuleA", OS2), VAL_B),
    OS1 != OS2,
	VAL_A == VAL_B+1.

% Symmetry breaking for positions. For each frame, and each module
% type, the mapping from modules of the same type to their positions
% must be monotonic, unless the association is given in the input
% partial instantiation.
:- 	ooasp_instantiation(M,I),
	ooasp_associated(I,"Frame_modules",F,M1),
	ooasp_associated(I,"Frame_modules",F,M2),
	not partial(ooasp_associated(I,"Frame_modules",F,M1)),
	not partial(ooasp_associated(I,"Frame_modules",F,M2)),
	ooasp_isa(I,C,M1), 
	ooasp_isa(I,C,M2),
	ooasp_attribute_value(I,"position",M1,V1),
	ooasp_attribute_value(I,"position",M2,V2),
	M1 < M2, V2 < V1.
