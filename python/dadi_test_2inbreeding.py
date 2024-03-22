
## Run dadi on simulated data


import sys

sys.path.insert(0, 'python/')

import dadi
from dadi_functions import run_dadi_2inb, two_epoch_inbreeding
import numpy as np

dd = dadi.Misc.make_data_dict_vcf("simulations/msprime_macleod/replicate1/chr1.vcf",
                                  "simulations/msprime_macleod/replicate1/popfile.txt")


fs = dadi.Spectrum.from_data_dict(dd, ["pop1"], projections = [20], polarized = False)



ns = fs.sample_sizes


pts = [max(ns)+20, max(ns)+30, max(ns)+40]

model = two_epoch_inbreeding
model = dadi.Numerics.make_anc_state_misid_func(model)
model_ex = dadi.Numerics.make_extrap_func(model)

## third parameter is proportion ancestral state misspecified
params = [1, 0.01, 0.01, 0.01]
lower_bounds = [1e-5, 1e-3, 1e-3, 1e-3]
upper_bounds = [5, 3, 1, 1]

nu, T, F, anc_error, theta0, loglik = run_dadi_2inb(fs, model_ex, pts, params, lower_bounds, upper_bounds, 20)

mu = 1e-8
L = 158534110

N_ref = theta0 / 4 / L / mu
N_now = N_ref * nu
t_gen = T * 2 * N_ref
