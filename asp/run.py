import sys
import shutil
from subprocess import run, PIPE, TimeoutExpired
import os

import json
import time
import argparse
import re


def call_clingo(clingo, input_names, timeout):

    cmd = [clingo,
        "--warn=no-atom-undefined",
        "--warn=no-file-included",
        "--warn=no-operation-undefined",
        "--warn=no-global-variable",
        "--outf=2"
    ] + input_names

    # Solving with 4 threads
    # cmd += ["-t4"]

    print(" ".join(cmd))

    start = time.time()
    output = run(cmd, stdout=PIPE, stderr=PIPE, timeout=timeout)
    end = time.time()

    if output.stderr:
        raise RuntimeError(f"Error: {output.stderr}")
    return output.stdout, end-start


def tokenize(s):
    """
    Splits the input string into tokens:
    - Parentheses: ( and )
    - Commas: ,
    - Double-quoted strings: "..."
    - Names/identifiers: sequence of letters/digits/underscores
    """
    token_pattern = r'"[^"]*"|\(|\)|,|[A-Za-z0-9_]\w*'
    return re.findall(token_pattern, s)


def parse_term(s):
    """
    Main entry point:
      1. Tokenizes the string.
      2. Recursively parses it.
      3. Returns the nested tuple structure.
    """
    tokens = tokenize(s)
    node, index = parse_expr(tokens, 0)
    if index != len(tokens):
        raise ValueError("Extra tokens remaining after parse.")
    return node


def parse_expr(tokens, i):
    """
    Parse a single 'Term':
    
      Term =
        '(' ArgList ')'           => (None, ( ... ))
      | NAME '(' ArgList ')'      => (NAME, ( ... ))
      | NAME                      => 'NAME'
    
    Returns (node, new_index).
    """
    if i >= len(tokens):
        raise ValueError("Unexpected end of tokens in _parse_expr.")

    token = tokens[i]

    # Case 1: Parenthesized expression => ( None, (...subterms...) )
    if token == '(':
        i += 1  # consume '('
        args, i = parse_arglist(tokens, i)
        if i >= len(tokens) or tokens[i] != ')':
            raise ValueError("Missing closing ')' in parenthesized expression.")
        i += 1  # consume ')'
        return (None, tuple(args)), i

    # Otherwise, it should be a name (quoted or unquoted)
    # Then we may or may not see '(' to indicate arguments.
    name = token

    # Consume name
    i += 1  

    if i < len(tokens) and tokens[i] == '(':
        # Parse arguments: (NAME, ( ... ))
        # Consume '('
        i += 1  
        args, i = parse_arglist(tokens, i)
        if i >= len(tokens) or tokens[i] != ')':
            raise ValueError("Missing closing ')' after function-like call.")
        # Consume ')'
        i += 1
        return (name, tuple(args)), i
    else:
        # No '(' follows => it's another bare name
        return name, i


def parse_arglist(tokens, i):
    """
    Parse a comma-separated list of terms (ArgList).
    
    ArgList = Term ( ',' Term )*
    """
    args = []
    # Must parse at least one term
    node, i = parse_expr(tokens, i)
    args.append(node)

    # Repeatedly parse ", Term"
    while i < len(tokens) and tokens[i] == ',':
        # Consume ','
        i += 1  
        node, i = parse_expr(tokens, i)
        args.append(node)

    return args, i


def to_string(node):
    """
    Recursively convert the nested tuple back into the original string form.
    
    - If node is a string, return it directly.
    - Otherwise node is a 2-tuple (label, children).
      * If label is None, it represents a parenthesized group like (term1, term2).
      * If label is a string, it represents something like label(term1, term2).
    """
    if isinstance(node, str):
        # Atomic string, may be with or without quotes
        return node

    # Otherwise, node is a two-element tuple
    label, children = node  # children is itself a tuple of sub-nodes

    # Convert child nodes into comma-separated string
    inside = ", ".join(to_string(child) for child in children)
    
    # If label is None, it's a parenthesized expression
    if label is None:
        return f"({inside})"
    else:
        return f"{label}({inside})"


def print_model(solution):

    atoms_dict = {}

    for atom in solution:

        parsed = parse_term(atom)
        atom_name = parsed[0]

        atom_name += '/' + str(len(parsed[1]))

        atoms_dict[atom_name] = atoms_dict.get(atom_name, set())
        atoms_dict[atom_name].add(parsed)

    for atom_name, atoms in sorted(atoms_dict.items()):

        print(atom_name)
        sorted_atoms = sorted(atoms)
        for atom in sorted_atoms:
            print(to_string(atom))
        print('')


def cleansed(all):
    # return [ val for val in s if val.startswith("at(") or val.startswith("assign(") ]
    return all


def show_solutions(ref_solutions_seet, solutions_set):

    my_ind = 0
    ref_ind = 0

    ref_solutions = sorted(ref_solutions_seet)
    solutions = sorted(solutions_set)

    for i in range(len(ref_solutions)):
        print(i)
        print_model(ref_solutions[i])

    exit()

    while my_ind < len(solutions) or ref_ind < len(ref_solutions):

        my_sol = solutions[my_ind] if my_ind < len(solutions) else []
        ref_sol = ref_solutions[ref_ind] if ref_ind < len(ref_solutions) else []

        if my_sol == []:

            print("Present only in ref:")
            print_model(ref_sol)
            ref_ind += 1

        elif ref_sol == []:

            print("Present only in mine:")
            print_model(my_sol)
            my_ind += 1

        elif cleansed(my_sol) == ref_sol:

            print(f"Correct: my={my_ind} ref={ref_ind}")
            my_ind += 1
            ref_ind += 1

        # Mine has extra solutions not present in ref as ref is farther along alphabetically
        elif my_sol < ref_sol:

            print("Present only in mine:")
            print_model(my_sol)
            my_ind += 1

        elif my_sol > ref_sol:

            print("Present only in ref:")
            print_model(ref_sol)
            ref_ind += 1

        print("MyInd", my_ind, len(solutions))
        print("SolutionInd", ref_ind, len(ref_solutions))


def get_solutions(output, optimize=True):

    solutions = frozenset([])
    if not output["Result"].startswith("UNSAT"):

        answer_sets = output["Call"][len(output["Call"])-1]["Witnesses"]

        # If optimization set, only get best cost answer sets
        if optimize:
            cost = output["Models"]['Costs'][0]
            solutions = [frozenset(w["Value"]) for w in answer_sets if w["Costs"][0] == cost]
        else:
            solutions = [frozenset(w["Value"]) for w in answer_sets]

    return frozenset(solutions)


def test_instance(args, instance):

    # Default timeout
    timeout = 180

    options = [args.encoding, args.instances + "/" + instance, "0"]

    # Call clingo and get solutions
    stdout, time = call_clingo("clingo", options, timeout)
    solutions = get_solutions(json.loads(stdout))

    # Get reference solutions
    inst_sol = instance[:-2] + "json"
    with open(args.solutions + "/" + inst_sol, "r") as infile:
        ref_solutions = get_solutions(json.load(infile))

    show_solutions(ref_solutions, solutions)

    return solutions == ref_solutions, time


def test(args):

    # Read instances and sort them
    instances_dir = os.listdir(args.instances)
    instances_dir.sort()

    # Loop over instances
    success = True
    for instance in instances_dir:
        message = f"{instance}: "
        try:
            result, time = test_instance(args, instance)
            if result:
                message += f"success in {time:.3f} seconds"
            else:
                success = False
                message += f"failure in {time:.3f} seconds"
        except Exception as e:
            success = False
            if isinstance(e, TimeoutExpired):
                message +=  "failure: timeout"
            else:
                message += f"failure: error: {str(e)}"
                raise e
        print(message)

    if success: print("SUCCESS")
    else: print("FAILURE")


# Command: python run.py -e modules-encoding.lp -i instances/test -s solutions/modules
def parse():

    parser = argparse.ArgumentParser(
        description="Test ASP encodings"
    )
    parser.add_argument("--encoding", "-e", metavar="<file>",
                        help="ASP encoding to test", required=True)
    parser.add_argument("--instances", "-i", metavar="<path>",
                        help="Directory of the instances", default="asp/instances", required=False)
    parser.add_argument("--solutions", "-s", metavar="<path>",
                        help="Directory of the solutions", default="asp/solutions", required=False)
    args = parser.parse_args()

    return args


test(parse())

