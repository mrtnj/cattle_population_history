
import sys
import pandas as pd
import msprime


out_path = sys.argv[1]


cattle_genome_table = pd.read_csv(
    "annotation/cattle_genome_table.txt",
    delimiter = "\t"
)


demography = msprime.Demography()
demography.add_population(name = "pop", initial_size = 100)
demography.add_population_parameters_change(
    time = 20,
    population = "pop",
    initial_size = 50
)
demography.add_population_parameters_change(
    time = 50,
    population = "pop",
    initial_size = 5_000
)


for chr_ix in range(len(cattle_genome_table)):
    rec_rate = cattle_genome_table.genetic_length[chr_ix]/100/cattle_genome_table.length[chr_ix]
    ts = msprime.sim_ancestry(
      samples = 20,
      recombination_rate = rec_rate,
      sequence_length = cattle_genome_table.length[chr_ix],
      demography = demography,
      model = [msprime.DiscreteTimeWrightFisher(duration = 50),
      msprime.StandardCoalescent()]
    )
    ts_mutated = msprime.sim_mutations(
      ts,
      rate = 1e-8
    )
    n_ind = int(ts.num_samples / 2)
    ids = [f"ind{i}" for i in range(n_ind)]
    vcf_file = open(out_path + "/" + cattle_genome_table.chr[chr_ix] + ".vcf", "w")
    ts_mutated.write_vcf(vcf_file, contig_id = cattle_genome_table.chr[chr_ix], individual_names = ids)


