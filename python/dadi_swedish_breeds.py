
## Run dadi on Fjällko and Rödkulla sequencing samples


import sys

sys.path.insert(0, 'python/')

import dadi
import dadi_functions
import numpy as np
import pandas

dd_fjall = dadi.Misc.make_data_dict_vcf("vcf/fjallko.vcf", "vcf/fjallko_popinfo.txt")
dd_rodkulla = dadi.Misc.make_data_dict_vcf("vcf/rodkulla.vcf", "vcf/rodkulla_popinfo.txt")

fs_fjall = dadi.Spectrum.from_data_dict(dd_fjall, ["pop1"], projections = [6], polarized = False)
fs_rodkulla = dadi.Spectrum.from_data_dict(dd_rodkulla, ["pop1"], projections = [8], polarized = False)

ns_fjall = fs_fjall.sample_sizes
ns_rodkulla = fs_rodkulla.sample_sizes

pts_fjall = [max(ns_fjall)+20, max(ns_fjall)+30, max(ns_fjall)+40]
pts_rodkulla = [max(ns_rodkulla)+20, max(ns_rodkulla)+30, max(ns_rodkulla)+40]


## Two epoch

model2 = dadi.Demographics1D.two_epoch
model2 = dadi.Numerics.make_anc_state_misid_func(model2)
model2_ex = dadi.Numerics.make_extrap_func(model2)

params2 = [1, 0.01, 0.01]
lower_bounds2 = [1e-5, 1e-3, 1e-3]
upper_bounds2 = [5, 3, 1]

pars2_fjall = run_dadi(fs_fjall, model2_ex, pts_fjall, params2, lower_bounds2, upper_bounds2, 20)

pars2_rodkulla = run_dadi(fs_rodkulla, model2_ex, pts_rodkulla, params2, lower_bounds2, upper_bounds2, 20)

mu = 1e-8
L = 2.6e9

conv_pars2_fjall = convert_pars_three_epoch_inbreeding(pars2_fjall, mu, L)
conv_pars2_rodkulla = convert_pars_three_epoch_inbreeding(pars2_rodkulla, mu, L)

conv_pars2_fjall.to_csv("outputs/dadi_fjallko_2epoch.csv")
conv_pars2_rodkulla.to_csv("outputs/dadi_fjallko_2epoch.csv")


## Three epoch inbreeding

model3 = dadi.Demographics1D.three_epoch_inbreeding
model3 = dadi.Numerics.make_anc_state_misid_func(model3)
model3_ex = dadi.Numerics.make_extrap_func(model3)

params3 = [1, 1, 0.01, 0.01, 0.01, 0.01]
lower_bounds3 = [1e-5, 1e-5, 1e-3, 1e-5, 1e-4, 1e-3]
upper_bounds3 = [5, 5, 3, 3, 1, 1]


pars3_fjall = run_dadi(fs_fjall, model3_ex, pts_fjall, params3, lower_bounds3, upper_bounds3, 20)
pars3_rodkulla = run_dadi(fs_rodkulla, model3_ex, pts_rodkulla, params3, lower_bounds3, upper_bounds3, 20)

conv_pars3_fjall = convert_pars_three_epoch_inbreeding(pars3_fjall, mu, L)
conv_pars3_rodkulla = convert_pars_three_epoch_inbreeding(pars3_rodkulla, mu, L)

conv_pars3_fjall.to_csv("outputs/dadi_fjallko_3epoch.csv")
conv_pars3_rodkulla.to_csv("outputs/dadi_rodkulla_3epoch.csv")
