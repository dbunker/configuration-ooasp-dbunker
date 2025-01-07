% Please insert the names and email addresses of the group members:
%
%

#const max_instance_per_leaf_class = 10.
#const int_domain_max = 20.

possible_instance_id(1..max_instance_per_leaf_class).

% generate attribute values
int_value(1..int_domain_max).
bool_value("TRUE").
bool_value("FALSE").

% input handling
ooasp_instantiation(M,I) :- partial(ooasp_instantiation(M,I)).
ooasp_isa(I,C,O) :- partial(ooasp_isa(I,C,O)).
ooasp_associated(I,A,O1,O2) :- partial(ooasp_associated(I,A,O1,O2)).
ooasp_attribute_value(I,AT,O,V) :- partial(ooasp_attribute_value(I,AT,O,V)).


% generate instantiation 
ooasp_instantiation(M, I) :- ooasp_isa(I, C, O), ooasp_class(M, C).

% instantiate objects using possible instance ids
{ ooasp_isa(I, C, (C,O)) } :-
	ooasp_instantiation(M, I), ooasp_class(M, C), not ooasp_subclass(M, _, C), possible_instance_id(O).

%
% Your encoding goes here...
%

% symmetry breaking and minimization

% instantiation of objects must be done in ascending order with no
% gaps, unless the objects is given as part of the input partial
% instantiation
:- ooasp_isa(I, C, (C,ID1)), not partial(ooasp_isa(I, C, (C,ID1))),
	 possible_instance_id(ID2), ID2 < ID1, not ooasp_isa(I, C, (C,ID2)).

% for each association, the mapping from the first object to the
% second must be monotonic, unless the association is given as part of
% the input partial instantiation
:- ooasp_associated(I,A,O1,O2), not partial(ooasp_associated(I,A,O1,O2)),
	 ooasp_associated(I,A,O3,O4),  not partial(ooasp_associated(I,A,O3,O4)),
	 O1 < O3, O4 < O2.

% minimize number of instantiated objects
#minimize { 1, I, C, O : ooasp_isa(I, C, O) }.

#show ooasp_instantiation/2.
#show ooasp_isa/3.
#show ooasp_associated/4.
#show ooasp_attribute_value/4.

#defined ooasp_attribute_enum/4.
#defined partial/1.
