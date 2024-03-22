
## Run dadi on simulated data


import sys

sys.path.insert(0, 'python/')

import dadi
import numpy as np

def four_epoch_inbreeding(params, ns, pts):
    nu1, nu2, nu3, T1, T2, T3, F = params

    xx = dadi.Numerics.default_grid(pts)
    phi = dadi.PhiManip.phi_1D(xx)

    phi = dadi.Integration.one_pop(phi, xx, T1, nu1)
    phi = dadi.Integration.one_pop(phi, xx, T2, nu2)
    phi = dadi.Integration.one_pop(phi, xx, T3, nu3)

    fs = dadi.Spectrum.from_phi_inbreeding(phi, ns, (xx,), (F,), (2,))
    return fs

def run_dadi_4inb(fs, model, pts, params, lower_bounds, upper_bounds, n_rep):
  nu1 = np.zeros(n_rep)
  nu2 = np.zeros(n_rep)
  nu3 = np.zeros(n_rep)
  T1 = np.zeros(n_rep)
  T2 = np.zeros(n_rep)
  T3 = np.zeros(n_rep)
  F = np.zeros(n_rep)
  anc_error = np.zeros(n_rep)
  theta0 = np.zeros(n_rep)
  loglik = np.zeros(n_rep)
  ns = fs.sample_sizes
  for rep in range(0, n_rep):
    p0 = dadi.Misc.perturb_params(params, fold=1, upper_bound=upper_bounds,
                                  lower_bound = lower_bounds)
    popt, ll_model = dadi.Inference.opt(p0, fs, model, pts,
                                        lower_bound=lower_bounds,
                                        upper_bound=upper_bounds,
                                        algorithm=nlopt.LN_BOBYQA,
                                        maxeval=600, verbose=0)
    model_fs = model(popt, ns, pts)
    theta0[rep] = dadi.Inference.optimal_sfs_scaling(model_fs, fs)
    loglik[rep] = ll_model
    nu1[rep] = popt[0]
    nu2[rep] = popt[1]
    nu3[rep] = popt[2]
    T1[rep] = popt[3]
    T2[rep] = popt[4]
    T3[rep] = popt[5]
    F[rep] = popt[6]
    anc_error[rep] = popt[7]
    print([ll_model] + list(popt) + [theta0[rep]])
  return nu1, nu2, nu3, T1, T2, T3, F, anc_error, theta0, loglik


dd = dadi.Misc.make_data_dict_vcf("simulations/msprime_macleod/replicate1/chr1.vcf",
                                  "simulations/msprime_macleod/replicate1/popfile.txt")


fs = dadi.Spectrum.from_data_dict(dd, ["pop1"], projections = [20], polarized = False)



ns = fs.sample_sizes


pts = [max(ns)+20, max(ns)+30, max(ns)+40]

model = four_epoch_inbreeding
model = dadi.Numerics.make_anc_state_misid_func(model)
model_ex = dadi.Numerics.make_extrap_func(model)

## last parameter is proportion ancestral state misspecified
params = [1, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01]
lower_bounds = [1e-5, 1e-5, 1e-5, 1e-3, 1e-3, 1e-3, 1e-3, 1e-3]
upper_bounds = [5, 5, 5, 3, 3, 3, 1, 1]

nu1, nu2, nu3, T1, T2, T3, F, anc_error, theta0, loglik = run_dadi_4inb(fs, model_ex, pts, params, lower_bounds, upper_bounds, 20)

mu = 1e-8
L = 158534110

N_ref = theta0 / 4 / L / mu
N1 = N_ref * nu1
N2 = N_ref * nu2
N3 = N_ref * nu3
T1_gen = T1 * 2 * N_ref
T2_gen = T2 * 2 * N_ref
T3_gen = T3 * 2 * N_ref

