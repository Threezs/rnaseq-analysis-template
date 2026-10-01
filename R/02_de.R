run_edger_ql <- function(counts, metadata, design_formula = ~ group) {
  if (!requireNamespace("edgeR", quietly = TRUE)) {
    stop("Install edgeR before running run_edger_ql()")
  }
  y <- edgeR::DGEList(counts = counts, group = metadata$group)
  keep <- edgeR::filterByExpr(y, design = model.matrix(design_formula, metadata))
  y <- y[keep, , keep.lib.sizes = FALSE]
  y <- edgeR::calcNormFactors(y)
  design <- model.matrix(design_formula, metadata)
  fit <- edgeR::glmQLFit(y, design, robust = TRUE)
  list(dge = y, design = design, fit = fit, keep = keep)
}

run_deseq2_wald <- function(counts, metadata, design_formula = ~ group) {
  if (!requireNamespace("DESeq2", quietly = TRUE)) {
    stop("Install DESeq2 before running run_deseq2_wald()")
  }
  coldata <- as.data.frame(metadata)
  rownames(coldata) <- coldata$sample_id
  dds <- DESeq2::DESeqDataSetFromMatrix(
    countData = round(counts[, coldata$sample_id, drop = FALSE]),
    colData = coldata,
    design = design_formula
  )
  dds <- dds[rowSums(DESeq2::counts(dds) >= 10) >= 2, ]
  DESeq2::DESeq(dds)
}

run_limma_voom <- function(counts, metadata, design_formula = ~ group) {
  if (!requireNamespace("limma", quietly = TRUE) ||
      !requireNamespace("edgeR", quietly = TRUE)) {
    stop("Install limma and edgeR before running run_limma_voom()")
  }
  dge <- edgeR::DGEList(counts = counts)
  keep <- edgeR::filterByExpr(dge, design = model.matrix(design_formula, metadata))
  dge <- dge[keep, , keep.lib.sizes = FALSE]
  dge <- edgeR::calcNormFactors(dge)
  v <- limma::voom(dge, model.matrix(design_formula, metadata), plot = FALSE)
  fit <- limma::lmFit(v, model.matrix(design_formula, metadata))
  limma::eBayes(fit, robust = TRUE)
}
