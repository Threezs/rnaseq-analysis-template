# Activity analyses should be treated as pathway-level inference, not direct protein measurements.

run_progeny <- function(expression_matrix, pathways, scale = TRUE) {
  if (!requireNamespace("decoupleR", quietly = TRUE)) {
    stop("Install decoupleR before running PROGENy")
  }
  decoupleR::run_mlm(
    mat = expression_matrix,
    net = pathways,
    .source = "source",
    .target = "target",
    .mor = "weight"
  )
}

# For mouse TF activity, prefer a species-matched network when possible.
# If a human network is mapped through orthologs, record the mapping source,
# one-to-many handling and the number of retained interactions in the report.
