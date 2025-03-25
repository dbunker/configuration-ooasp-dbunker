
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Instantiation

% ooasp_instantiation(M, I)
% ooasp_instantiation("v1", "c1")
% Model M has an instance I
% Model "v1" has an instance "c1"

% ooasp_isa(I, C, O)
% ooasp_isa("c1", "ElementA", ("ElementA", 10))
% For model instance I, class C is the class of object O
% For model instance "c1", class "ElementA" is class of object ("ElementA", 10)

% ooasp_associated(I, A, O1, O2)
% ooasp_associated("c1", "ElementA_moduleA", ("ElementA", 10), ("ModuleA", 1))
% For instance I, relation A connects objects O1 and O2
% For instance "c1", relation "ElementA_moduleA" connects objects ("ElementA", 10) and ("ModuleA", 1)

% ooasp_attribute_value(I, AT, O, VAL)
% ooasp_attribute_value("c1", "position", ("ModuleA", 1), 1)
% For instance I, attribute AT of object O has value VAL
% For instance "c1", attribute "position" of object ("ModuleA", 1) has value 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Models

% ooasp_class(M, C)
% ooasp_class("v1", "HwObject")
% Model M has class C that follows it
% Model "v1" has class "HwObject" that follows it

% ooasp_subclass(M, C, SC)
% ooasp_subclass("v1", "Frame", "HwObject")
% Model M with class C has super class SC
% Model "v1" with class "Frame" has super class "HwObject"

% ooasp_assoc(M, A, C1, MIN_C1, MAX_C1, C2, MIN_C2, MAX_C2)
% ooasp_assoc("v1", "Frame_modules", "Frame", 1, 1, "Module", 0, 5)
% Model M has relation association A between class C1 and C2, where for every instance C1 
% between MIN_C1 and MAX_C1, there must be between MIN_C2 and MAX_C2 instances of C2 
% Model "v1" has relation association  "Frame_modules" between class "Frame" and "Module", where for every instance "Frame" 
% between 1 and 1 there must be between 0 and 5 instances of "Module"

% ooasp_attribute(M, C, AT, {"string", "integer", "boolean"})
% ooasp_attribute("v1", "Module", "position", "integer")
% Model M is associated with class C that has attribute AT with type "string", "integer", or "boolean"
% Model "v1" is associated with  to class "Module" that has attribute "position" with type "integer"

% ooasp_attribute_minInclusive(M, C, AT, MIN_V)
% ooasp_attribute_minInclusive("v1", "Module", "position", 1)
% Model M is associated with class C that has attribute AT with minimum value MIN_V
% Model "v1" is associated with  to class "Module" that has attribute "position" with minimum value 1

% ooasp_attribute_maxInclusive(M, C, AT, MAX_V)
% ooasp_attribute_maxInclusive("v1", "Module", "position", 5)
% Model M is associated with class C that has attribute AT with maximum value MAX_V
% Model "v1" is associated with  to class "Module" that has attribute "position" with maximum value 5

% ooasp_attribute_enum(M, C, AT, VAL)
% ooasp_attribute_enum("v1", "Frame", "gears", "Hub")
% Model M is associated with class C that has attribute AT with possible value VAL
% Model "v1" is associated with  to class "Module" that has attribute "gears" with possible value "Hub"

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constraints

% ooasp_cv(I, minviolated(O1, A))
% For instance I, minimum constraint violated for object O1, attribute A

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#const max_instance_per_leaf_class = 10.
#const int_domain_max = 20.

possible_instance_id(1..max_instance_per_leaf_class).

% Generate attribute values
int_value(1..int_domain_max).
bool_value("TRUE").
bool_value("FALSE").

% Input handling
ooasp_instantiation(M, I) :- partial(ooasp_instantiation(M, I)).
ooasp_isa(I, C, O) :- partial(ooasp_isa(I, C, O)).
ooasp_associated(I, A, O1, O2) :- partial(ooasp_associated(I, A, O1, O2)).
ooasp_attribute_value(I, AT, O, V) :- partial(ooasp_attribute_value(I, AT, O, V)).

% Generate instantiation 
ooasp_instantiation(M, I) :- ooasp_isa(I, C, O), ooasp_class(M, C).

% Instantiate objects using possible instance ids
{ ooasp_isa(I, C, (C, O)) } :-
    ooasp_instantiation(M, I), ooasp_class(M, C), not ooasp_subclass(M, _, C), possible_instance_id(O).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extend to superclasses

% Base case
% (CS, OS) is base (class, object)
ooasp_full_isa(I, C, (CS, OS)) :-
    ooasp_isa(I, C, (CS, OS)).

% Extend
ooasp_full_isa(I, C_SUPER, (CS, OS)) :-
    ooasp_instantiation(M, I),
    ooasp_subclass(M, C_MID, C_SUPER),
    ooasp_full_isa(I, C_MID, (CS, OS)).
% #show ooasp_full_isa/3.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate ooasp_associated

% Generate possible ooasp_associated based on assoc
% Ex. ooasp_associated("c1", "ElementA_moduleA", ("ElementA", 10), ("ModuleA", 1))
% Ex. ooasp_assoc("v1", "Frame_modules", "Frame", 1, 1, "Module", 0, 5)
{ ooasp_associated(I, A, (CS1, OS1), (CS2, OS2)) } :-
    ooasp_instantiation(M, I),
    ooasp_assoc(M, A, C1, _, _, C2, _, _),
    ooasp_full_isa(I, C1, (CS1, OS1)),
    ooasp_full_isa(I, C2, (CS2, OS2)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Count associated and match to assoc min and max

% Each associating class is attached to an associated class which exists, or must be created
% Get the number of currently associated ex. ("ElementA", 10) has 1 associated "ModuleA"
% This is limited by ooasp_assoc min and max

% Ex. ooasp_associated("c1", "Frame_modules", ("Frame", 1), ("ModuleA", _)).
% EX. ooasp_assoc("v1", "Frame_modules", "Frame", 1, 1, "Module", 0, 5)

% Total count for each associated object to class pair C1 to C2 followed by max and min allowes
number_associated(I, (C1, (CS1, OS1)), C2, NUM, MIN_C2, MAX_C2) :-
    ooasp_instantiation(M, I),
    ooasp_full_isa(I, C1, (CS1, OS1)),
    ooasp_assoc(M, A, C1, _, _, C2, MIN_C2, MAX_C2),
    NUM = #count { CS2, OS2 : ooasp_associated(I, A, (CS1, OS1), (CS2, OS2)) }.

% Total count for each associated object to class pair C2 to C1 followed by max and min allowes
number_associated(I, (C2, (CS2, OS2)), C1, NUM, MIN_C1, MAX_C1) :-
    ooasp_instantiation(M, I),
    ooasp_full_isa(I, C2, (CS2, OS2)),
    ooasp_assoc(M, A, C1, MIN_C1, MAX_C1, C2, _, _),
    NUM = #count { CS1, OS1 : ooasp_associated(I, A, (CS1, OS1), (CS2, OS2)) }.
% #show number_associated/6.

:-  number_associated(_, _, _, NUM, MIN, _),
    NUM < MIN.

:-  number_associated(_, _, _, NUM, _, MAX),
    NUM > MAX.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enforce different object use

% For each associated (CS1, OS1), (CS2, OS2) (ex. ("ElementA", 10), ("ModuleA", 1))
% if OS1_A and OS1_B are different OS2_A and OS2_B must also be different
:-  ooasp_associated(I, A, (CS1, OS1_A), (CS2, OS2_A)),
    ooasp_associated(I, A, (CS1, OS1_B), (CS2, OS2_B)),
    OS1_A != OS1_B,
    OS2_A == OS2_B.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Superclass associations

% Must have ooasp_associated for superclass
% Ex. ooasp_associated("c1", "Element_module", ("ElementA", 10), ("ModuleA", 1))
% Ex. ooasp_subclass("v1", "ElementA", "Element")
:-  not ooasp_associated(I, A, (CS1, OS1), (CS2, OS2)),
    ooasp_instantiation(M, I),
    ooasp_associated(I, AS, (CS1, OS1), (CS2, OS2)),
    ooasp_full_isa(I, C1, (CS1, OS1)),
    ooasp_full_isa(I, C2, (CS2, OS2)),
    ooasp_assoc(M, A, C1, 1, 1, C2, _, _).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Attribute values

% Ex. ooasp_attribute_value(I, AT, O, VAL)
% Ex. ooasp_attribute_value("c1", "position", ("ModuleA", 1), 1)

% Ex. ooasp_attribute("v1", "Module", "position", "integer").
% Ex. ooasp_attribute_minInclusive("v1", "Module", "position", 1).

% For instance I, attribute AT of object O has value VAL
% For instance "c1", attribute "position" of object ("ModuleA", 1) has value 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Integer

% The ooasp_attribute_value must have one integer value for integer
{ ooasp_attribute_value(I, AT, (CS, OS), VAL) } :-
    ooasp_instantiation(M, I),
    ooasp_full_isa(I, C, (CS, OS)),
    ooasp_attribute(M, C, AT, "integer"),
    ooasp_attribute_minInclusive(M, C, AT, MIN),
    ooasp_attribute_maxInclusive(M, C, AT, MAX),
    int_value(VAL),
    VAL >= MIN,
    VAL <= MAX.

% Enforce int rule
:-  ooasp_attribute_value(I, AT, (CS, OS), VAL),
    ooasp_instantiation(M, I),
    ooasp_full_isa(I, C, (CS, OS)),
    ooasp_attribute(M, C, AT, "integer"),
    not int_value(VAL).

% Enforce min rule
:-  ooasp_attribute_value(I, AT, (CS, OS), VAL),
    ooasp_instantiation(M, I),
    ooasp_full_isa(I, C, (CS, OS)),
    ooasp_attribute(M, C, AT, "integer"),
    ooasp_attribute_minInclusive(M, C, AT, MIN),
    VAL < MIN.

% Enforce max rule
:-  ooasp_attribute_value(I, AT, (CS, OS), VAL),
    ooasp_instantiation(M, I),
    ooasp_full_isa(I, C, (CS, OS)),
    ooasp_attribute(M, C, AT, "integer"),
    ooasp_attribute_maxInclusive(M, C, AT, MAX),
    VAL > MAX. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bolean

% Same construction for boolean
{ ooasp_attribute_value(I, AT, (CS, OS), VAL) } :-
    ooasp_instantiation(M, I),
    ooasp_full_isa(I, C, (CS, OS)),
    ooasp_attribute(M, C, AT, "boolean"),
    bool_value(VAL).

% Enforce bool value rule
:-  ooasp_attribute_value(I, AT, (CS, OS), VAL),
    ooasp_instantiation(M, I),
    ooasp_full_isa(I, C, (CS, OS)),
    ooasp_attribute(M, C, AT, "boolean"),
    not bool_value(VAL).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% String enums

% Ex. ooasp_attribute_enum("v1", "Frame", "gears", "Hub").
% Constraints on string type
{ ooasp_attribute_value(I, AT, (CS, OS), VAL) } :-
    ooasp_instantiation(M, I),
    ooasp_full_isa(I, C, (CS, OS)),
    ooasp_attribute(M, C, AT, "string"),
    ooasp_attribute_enum(M, C, AT, VAL).

% Enforce string value rule
:-  ooasp_attribute_value(I, AT, (CS, OS), VAL),
    ooasp_instantiation(M, I),
    ooasp_full_isa(I, C, (CS, OS)),
    ooasp_attribute(M, C, AT, "string"),
    not ooasp_attribute_enum(M, C, AT, VAL).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enforce exactly one value rule for all

% Must exist
:-  not ooasp_attribute_value(I, AT, (CS, OS), _),
    ooasp_instantiation(M, I),
    ooasp_full_isa(I, C, (CS, OS)),
    ooasp_attribute(M, C, AT, _).

% Cannot have duplicates
:-  ooasp_attribute_value(I, AT, (CS, OS), VAL_A),
    ooasp_attribute_value(I, AT, (CS, OS), VAL_B),
    VAL_A != VAL_B.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Symmetry breaking and minimization

% Instantiation of objects must be done in ascending order with no
% gaps, unless the objects is given as part of the input partial
% instantiation
:- ooasp_isa(I, C, (C,ID1)), not partial(ooasp_isa(I, C, (C,ID1))),
    possible_instance_id(ID2), ID2 < ID1, not ooasp_isa(I, C, (C,ID2)).

% For each association, the mapping from the first object to the
% second must be monotonic, unless the association is given as part of
% the input partial instantiation
:- ooasp_associated(I,A,O1,O2), not partial(ooasp_associated(I,A,O1,O2)),
    ooasp_associated(I,A,O3,O4), not partial(ooasp_associated(I,A,O3,O4)),
    O1 < O3, O4 < O2.

% Minimize number of instantiated objects
#minimize { 1, I, C, O : ooasp_isa(I, C, O) }.

#show ooasp_instantiation/2.
#show ooasp_isa/3.
#show ooasp_associated/4.
#show ooasp_attribute_value/4.

#defined ooasp_attribute_enum/4.
#defined partial/1.
