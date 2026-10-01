# Statistical decisions for small bulk RNA-seq experiments

## Replicates

With four controls and three APAP samples, a two-group model is statistically estimable. The result is still limited by biological variation and modest power, so effect sizes, confidence intervals where available, QC plots and cross-method agreement matter more than a long list of FDR-significant genes.

## Primary method

Use edgeR quasi-likelihood (QL) as the primary analysis when the input is raw integer counts and the design is small:

- negative-binomial mean-variance modeling is appropriate for count data;
- `filterByExpr()` uses the design and group sizes rather than an arbitrary global threshold;
- QL moderation gives an additional layer of uncertainty control beyond the dispersion estimate;
- robust fitting can reduce the influence of an outlying library.

DESeq2 Wald and limma-voom should be run as sensitivity analyses. Concordance is evidence of stability; disagreement is a reason to inspect dispersion, batch, library size, and influential samples.

## Filtering and universe

Run `edgeR::filterByExpr()` before normalization/model fitting. For ORA, use genes retained by this filter as the universe. Do not use all annotated genes, because genes that were not detectably expressed could not have been selected.

## ORA

Use genes that pass a prespecified adjusted-p and effect-size rule. If combining DESeq2, edgeR QL and limma-voom, record that the intersection is a conservative high-confidence set rather than an unbiased estimate of the full response. Keep up and down genes separate, preserve gene identifiers and report the term2gene version.

## GSEA and competitive gene-set tests

Use a signed statistic over all tested genes. A DESeq2 Wald statistic is acceptable when its sign is retained. fgsea, camera, fry and ROAST answer related but different questions; report the method and gene-set database separately.

## Activity methods

PROGENy, GSVA/ssGSEA and VIPER infer pathway or regulator activity from expression footprints. They do not measure phosphorylation or protein abundance directly. For mouse TF activity, prefer mouse-native regulons. If a human network is mapped through orthologs, keep the mapping table, one-to-many rule, retained-interaction count and database version.

## Audit checklist

- [ ] Experimental unit and biological replicate are explicit.
- [ ] Count matrix is raw integer data.
- [ ] Metadata order matches count columns.
- [ ] Batch is included only when estimable and biologically justified.
- [ ] Low-expression filtering is design-aware.
- [ ] Primary contrast and reference level are recorded.
- [ ] Full result tables are saved.
- [ ] ORA universe is the filtered expressed set.
- [ ] GSEA ranking is prespecified.
- [ ] Methods and database versions are recorded.
