
% modules example kb "v1"
% classes
ooasp_class("v1", "HwObject").
ooasp_class("v1", "Frame").
ooasp_class("v1", "Module").
ooasp_class("v1", "ModuleA"). 
ooasp_class("v1", "ModuleB").
ooasp_class("v1", "Element").
ooasp_class("v1", "ElementA"). 
ooasp_class("v1", "ElementB").

% class inheritance
ooasp_subclass("v1", "Frame", "HwObject").
ooasp_subclass("v1", "Module", "HwObject").
ooasp_subclass("v1", "Element", "HwObject").
ooasp_subclass("v1", "ElementA", "Element").
ooasp_subclass("v1", "ElementB", "Element").
ooasp_subclass("v1", "ModuleA", "Module").
ooasp_subclass("v1", "ModuleB", "Module").

% attributes and associations
% class Frame
ooasp_assoc("v1", "Frame_modules", "Frame", 1, 1, "Module", 0, 5).

% class Module
ooasp_attribute("v1", "Module", "position", "integer").
ooasp_attribute_minInclusive("v1", "Module", "position", 1).
ooasp_attribute_maxInclusive("v1", "Module", "position", 5).

% class Element
ooasp_assoc("v1", "Element_module", "Element", 1, 1, "Module", 1, 1).
ooasp_assoc("v1", "ElementA_moduleA", "ElementA", 1, 1, "ModuleA", 1, 1).
ooasp_assoc("v1", "ElementB_moduleB", "ElementB", 1, 1, "ModuleB", 1, 1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% partial encoding

partial(ooasp_instantiation("v1", "c1")).
partial(ooasp_isa("c1", "ElementA", ("ElementA", 10..12))).
partial(ooasp_isa("c1", "ElementB", ("ElementB", 13..14))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ooasp_isa("c1", "ElementA", ("ElementA", 10))
% ooasp_isa("c1", "ElementA", ("ElementA", 11))
% ooasp_isa("c1", "ElementA", ("ElementA", 12))
% ooasp_isa("c1", "ElementB", ("ElementB", 13))
% ooasp_isa("c1", "ElementB", ("ElementB", 14))


% Due to: 
%   ooasp_assoc(M, A, C1, MIN_C1, MAX_C1, C2, MIN_C2, MAX_C2),
%   ooasp_assoc("v1", "ElementA_moduleA", "ElementA", 1, 1, "ModuleA", 1, 1).
%   ooasp_isa(I, C, (C, O))
%   ooasp_isa("c1", "ElementA", ("ElementA", 10))

% ooasp_associated(I, A, (C1, O1), (C2, O2)) }
% ooasp_associated("c1", "ElementA_moduleA", ("ElementA", 10), ("ModuleA", 1))


