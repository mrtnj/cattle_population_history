
## Run dadi on simulated data


import sys

sys.path.insert(0, 'python/')

import dadi
import dadi_functions 
import numpy as np

dd = dadi.Misc.make_data_dict_vcf("simulations/msprime_decline/replicate1/chr1.vcf",
                                  "simulations/msprime_decline/replicate1/popfile.txt")


fs = dadi.Spectrum.from_data_dict(dd, ["pop1"], projections = [20], polarized = False)



ns = fs.sample_sizes


pts = [max(ns)+20, max(ns)+30, max(ns)+40]

model = dadi.Demographics1D.three_epoch_inbreeding
model = dadi.Numerics.make_anc_state_misid_func(model)
model_ex = dadi.Numerics.make_extrap_func(model)

## third parameter is proportion ancestral state misspecified
params = [1, 1, 0.01, 0.01, 0.01, 0.01]
lower_bounds = [1e-5, 1e-5, 1e-3, 1e-5, 1e-4, 1e-3]
upper_bounds = [5, 5, 3, 3, 1, 1]

pars = run_dadi(fs, model_ex, pts, params, lower_bounds, upper_bounds, 20)


mu = 1e-8
L = 158534110

convert_pars_three_epoch_inbreeding(pars, mu, L)

