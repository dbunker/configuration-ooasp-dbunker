#include "./ooasp.lp".

% domain specific constraints below

% Two modules in the same frame cannot have the same position.
%
% Your domain-specific constraint goes here...


% Two modules of type ModuleA may not be adjacent to each other.
%
% Your domain-specific constraint goes here...


% symmetry breaking for positions. For each frame, and each module
% type, the mapping from modules of the same type to their positions
% must be monotonic, unless the association is given in the input
% partial instantiation.
:- ooasp_instantiation(M,I),
	 ooasp_associated(I,"Frame_modules",F,M1),
	 ooasp_associated(I,"Frame_modules",F,M2),
	 not partial(ooasp_associated(I,"Frame_modules",F,M1)),
	 not partial(ooasp_associated(I,"Frame_modules",F,M2)),
	 ooasp_isa(I,C,M1), 
	 ooasp_isa(I,C,M2),
	 ooasp_attribute_value(I,"position",M1,V1),
	 ooasp_attribute_value(I,"position",M2,V2),
	 M1 < M2, V2 < V1.
