# Configuration project - OOASP

## Tasks of the project

The goal of this project is to write an encoding implementing OOASP, as described in the paper: OOASP: Connecting Object-Oriented and Logic Programming. We have also made a slight extension/modification to OOASP for this project to limit the search space for faster testing of your encoding.

The main file of the project is [ooasp.lp](asp/ooasp.lp), which will contain your implementation of OOASP. This encoding will take as an input instance a configuration model defined via the predicates of Table 1 of the paper, and a partial instantiation defined via the predicates in Table 2, additionally being wrapped in the `partial/1` predicate. The **first part of this project** is to implement this encoding yourself.

The project comes with a test suite on two configuration models, namely the Modules model as seen in the paper, and additionally a novel Bikes model. The test instances are found in the `asp/instances` folder, while their solutions (in json format) can be found in the `asp/solutions` folder.

To see an example configuration model and partial instantiation, please refer to `modules-1.lp`, which describes the partial instantiation used as example in the paper on page 11.

**Additionally**, you will have to implement some domain-specific constraints for both configuration domains. These constraints should be defined in  [modules-encoding.lp](asp/modules-encoding.lp) and [bike-encoding.lp](asp/bike-encoding.lp), respectively. In these files, there is one comment describing each domain-specific constraint to be implemented by you. Note that in the Modules domain, these domain-specific constraints are the ones used as an example in the paper. An additional domain-specific constraint is already implemented for symmetry breaking for the positions of modules.

And last but not least, as the **final part of the project**, you must define a configuration model of your own, and come up with some example instances to test it on. The domain may be any configuration problem of your choosing.

## Extension of OOASP given in ooasp.lp

Note that from the OOASP definition of the paper, the ooasp.lp encoding already contains an extension of the problem that limits the search space. We search only for a minimal models with no symmetries, by imposing the following constraints:

1. We minimize over the number of instantiated objects.
2. We add symmetry breaking over object instantiation by instantiating object identifier sequentially with no gaps.
3. We add symmetry breaking over associations by making the mapping from objects defined via association monotonic.

These three extension are implemented via the final 2 rules and minimize statement pre-included in the encoding, and should not be modified.

## Summary and commands

In summary, to submit your solution, please modify the files [ooasp.lp](asp/ooasp.lp), [modules-encoding.lp](asp/modules-encoding.lp) and [bike-encoding.lp](asp/bike-encoding.lp) of the directory [asp](asp) with your encoding, and come up with your own configuration model and instances.

To pass the project, your encoding must succeed against are the following test commands:
* `python asp/test.py -e asp/modules-encoding.lp -i asp/instances/modules/ -s asp/solutions/modules/ -t 100 -opt`
* `python asp/test.py -e asp/bike-encoding.lp -i asp/instances/bike/ -s asp/solutions/bike/ -t 100 -opt`

For each instance, you will see if the test is a:
* "success" (correct answer),
* "failure" (wrong answer),
* "timeout" (no solution found before the time runs out), or
* "error" (clingo error).

For help, type `python3.8 asp/test.py --help`.

To run your encoding yourself on a specific instance, you can use a command of the following form:
* `clingo ./asp/instances/modules/modules-1.lp ./asp/modules-encoding.lp --opt-mode=optN`

The option `--opt=mode=optN` configures clingo to find and optimal model (i.e. one with the least amount of objects), and then enumerates all optimal models. These models are the ones we are interested in, and the ones the test script tests for. You can print the output in json format if you want by using the `--outf=2` option. For more details on clingo options, use `--help=3`.
