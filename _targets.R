library(targets)
tar_option_set(
  packages = c("yaml", "readr"),
  error = "abridged"
)
tar_source("R")

list(
  tar_target(config, yaml::read_yaml("config/project.yml")),
  tar_target(counts_file, config$input_counts, format = "file"),
  tar_target(metadata_file, config$input_metadata, format = "file"),
  tar_target(counts, read_count_matrix(counts_file)),
  tar_target(metadata, read_sample_metadata(metadata_file)),
  tar_target(input_check, validate_input(counts, metadata))
  # Add optional DE targets after installing Bioconductor packages:
  # tar_target(edger_fit, run_edger_ql(input_check$counts, input_check$metadata)),
  # tar_target(deseq2_fit, run_deseq2_wald(input_check$counts, input_check$metadata)),
  # tar_target(limma_fit, run_limma_voom(input_check$counts, input_check$metadata))
)
