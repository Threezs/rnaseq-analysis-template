read_count_matrix <- function(path) {
  x <- read.csv(path, row.names = 1, check.names = FALSE)
  if (anyNA(x)) stop("Counts contain NA values")
  if (any(x < 0)) stop("Counts contain negative values")
  if (any(x != round(x))) stop("Raw count matrix must contain integers")
  x
}

read_sample_metadata <- function(path) {
  x <- read.csv(path, check.names = FALSE, stringsAsFactors = FALSE)
  required <- c("sample_id", "group")
  missing <- setdiff(required, names(x))
  if (length(missing)) stop("Metadata missing: ", paste(missing, collapse = ", "))
  if (anyDuplicated(x$sample_id)) stop("Duplicate sample_id")
  x
}

validate_input <- function(counts, metadata) {
  if (!all(metadata$sample_id %in% colnames(counts))) {
    stop("Every metadata sample_id must be a count-matrix column")
  }
  if (!all(metadata$sample_id == colnames(counts))) {
    warning("Reordering counts to metadata sample order")
    counts <- counts[, metadata$sample_id, drop = FALSE]
  }
  list(counts = counts, metadata = metadata)
}
