import numpy as np
import pandas
import dadi
import nlopt


def two_epoch_inbreeding(params, ns, pts):
    """
    Instantaneous size change some time ago.

    params = (nu,T, F)
    ns = (n1,)

    nu: Ratio of contemporary to ancient population size
    T: Time in the past at which size change happened (in units of 2*Na 
       generations) 
    n1: Number of samples in resulting Spectrum
    pts: Number of grid points to use in integration.
    """
    nu,T,F = params

    xx = dadi.Numerics.default_grid(pts)
    phi = dadi.PhiManip.phi_1D(xx)
    
    phi = dadi.Integration.one_pop(phi, xx, T, nu)

    fs = dadi.Spectrum.from_phi_inbreeding(phi, ns, (xx,), (F,), (2,))
    return fs



def run_dadi(fs, model, pts, params, lower_bounds, upper_bounds, n_rep):
  pars = [None] * n_rep
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
    pars[rep] = popt
    print([ll_model] + list(popt) + [theta0[rep]])
  results = pandas.DataFrame(pars)
  results["theta0"] = theta0
  results["loglik"] = loglik
  return results

def convert_pars_two_epoch(pars, mu, L):
  pars.rename(columns = {0: "nu", 1: "T", 2: "anc_error"}, inplace = True)
  pars["N_ref"] = pars["theta0"] / 4 / L / mu
  pars["N_now"] = pars["N_ref"] * pars["nu"]
  pars["t_gen"] = pars["T"] * 2 *pars["N_ref"]
  return pars


def convert_pars_three_epoch_inbreeding(pars, mu, L):
  pars.rename(columns = {0: "nuB", 1: "nuF", 2: "TB", 3: "TF", 4: "F", 5: "anc_error"}, inplace = True)
  pars["N_ref"] = pars["theta0"] / 4 / L / mu
  pars["N_now"] = pars["N_ref"] * pars["nuF"]
  pars["N_bot"] = pars["N_ref"] * pars["nuB"]
  pars["t_bot_gen"] = pars["TB"] * 2 * pars["N_ref"]
  pars["t_recovery_gen"] = pars["TF"] * 2 * pars["N_ref"]
  pars["t_gen"] = pars["t_bot_gen"] + pars["t_recovery_gen"]
  return pars



