
## Use msprime to simulate data from an estimated GONE population history

import pandas as pd
import msprime


cattle_genome_table = pd.read_csv(
    "annotation/cattle_genome_table.txt",
    delimiter = "\t"
)

history = pd.read_csv("population_histories/gone_fjall_chip.csv")


demography = msprime.Demography()
demography.add_population(name = "pop", initial_size = history["Ne"][0])

for change_ix in range(1, len(history)):
  demography.add_population_parameters_change(
      time = history["generations_ago"][change_ix],
      population = "pop",
      initial_size = history["Ne"][change_ix]
  )


for chr_ix in range(len(cattle_genome_table)):
    rec_rate = cattle_genome_table.genetic_length[chr_ix]/100/cattle_genome_table.length[chr_ix]
    ts = msprime.sim_ancestry(
      samples = 20,
      recombination_rate = rec_rate,
      sequence_length = cattle_genome_table.length[chr_ix],
      demography = demography,
      model = [msprime.DiscreteTimeWrightFisher(duration = 200),
      msprime.StandardCoalescent()]
    )
    ts_mutated = msprime.sim_mutations(
      ts,
      rate = 1e-8
    )
    n_ind = int(ts.num_samples / 2)
    ids = [f"ind{i}" for i in range(n_ind)]
    vcf_file = open("simulations/msprime_fjall/replicate1/" + cattle_genome_table.chr[chr_ix] + ".vcf", "w")
    ts_mutated.write_vcf(vcf_file, contig_id = cattle_genome_table.chr[chr_ix], individual_names = ids)


## Save haplotype matrix
# import numpy
# numpy.savetxt(
#     "simulations/msprime_decline/chr1.txt",
#     ts_mutated.genotype_matrix(),
#     fmt = "%1d"
# )