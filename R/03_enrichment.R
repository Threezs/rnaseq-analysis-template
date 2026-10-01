make_rank_vector <- function(result_table, stat_col = "stat") {
  stopifnot(all(c("gene_id", stat_col) %in% names(result_table)))
  x <- result_table[[stat_col]]
  names(x) <- result_table$gene_id
  x <- x[is.finite(x)]
  x[!duplicated(names(x))]
}

run_ora_enricher <- function(gene_ids, universe, term2gene, term2name = NULL) {
  if (!requireNamespace("clusterProfiler", quietly = TRUE)) {
    stop("Install clusterProfiler before running ORA")
  }
  clusterProfiler::enricher(
    gene = gene_ids,
    universe = universe,
    TERM2GENE = term2gene,
    TERM2NAME = term2name,
    pAdjustMethod = "BH",
    pvalueCutoff = 0.05,
    qvalueCutoff = 0.2
  )
}

run_gsea_fgsea <- function(stats, pathways) {
  if (!requireNamespace("fgsea", quietly = TRUE)) {
    stop("Install fgsea before running GSEA")
  }
  fgsea::fgseaMultilevel(pathways = pathways, stats = stats)
}
