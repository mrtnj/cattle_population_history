
## Use msprime to simulate diversity from estimated population history

import pandas as pd
import numpy
import msprime
import sys



population_history_file = sys.argv[1]
out_path = sys.argv[2]

extra_generations = 200

cattle_genome_table = pd.read_csv(
    "annotation/cattle_genome_table.txt",
    delimiter = "\t"
)

history = pd.read_csv(population_history_file)
history["generations_ago"] = history["generations_ago"] + extra_generations 

demography = msprime.Demography()
demography.add_population(name = "pop", initial_size = history["Ne"][0])

for change_ix in range(1, len(history)):
  demography.add_population_parameters_change(
      time = history["generations_ago"][change_ix],
      population = "pop",
      initial_size = history["Ne"][change_ix]
  )

seq = [ x * 10 for x in range(1, 41)]


samples = []
for i in range(0, 40):
  samples.append(msprime.SampleSet(20, time = seq[i]))
  


chr_ix = 0
rec_rate = cattle_genome_table.genetic_length[chr_ix]/100/cattle_genome_table.length[chr_ix]
ts = msprime.sim_ancestry(
  samples = samples,
  recombination_rate = rec_rate,
  sequence_length = cattle_genome_table.length[chr_ix],
  demography = demography,
  model = [msprime.DiscreteTimeWrightFisher(duration = 400),
  msprime.StandardCoalescent()]
)

ts_mutated = msprime.sim_mutations(
    ts,
    rate = 1e-8
  )


samples_pi = numpy.array_split(numpy.array(ts.samples()), 40)

pi = ts_mutated.diversity(sample_sets = samples_pi)


results = pd.DataFrame(data = { "gen": seq, "pi": pi})
results.to_csv(out_path)
