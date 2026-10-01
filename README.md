# RNA-seq Analysis Template

这是一个 R-first 的 bulk RNA-seq 分析模板，面向小鼠或人类的原始整数 count/UMI 矩阵。默认分析主线是：

~~~text
counts + sample metadata
        ↓
输入核查与低表达过滤
        ↓
样本 QC、库深度、相关性、PCA
        ↓
edgeR quasi-likelihood 主分析
        ↓
DESeq2 Wald + limma-voom 敏感性分析
        ↓
共同显著且方向一致的 ORA
        ↓
全基因排序 GSEA / camera / fry / ROAST
        ↓
PROGENy、GSVA/ssGSEA、VIPER/TF 活性
        ↓
Quarto 报告与审计记录
~~~

## 适合当前项目的默认设计

`data/mock/sample_metadata.csv` 演示 Control=4、APAP=3。实际项目中要把 `group`、`batch`、`sex`、`timepoint` 和实验单位写清楚。

- 设计公式：最简单的两组比较为 `~ group`。
- 如果存在批次并且每个组在每个批次都有样本：使用 `~ batch + group`。
- 如果动物是实验单位，不要把同一动物的技术重复当作独立生物学重复。
- 先用 `edgeR::filterByExpr()` 过滤低表达基因，再做归一化和差异检验。
- edgeR QL 作为主结果；DESeq2 和 limma-voom 作为稳健性与方向核对。
- ORA 的背景使用过滤后的表达基因，而不是全基因组。
- GSEA 使用全基因排序，避免只在显著基因上再次阈值化。

## 开始运行

~~~r
install.packages(c("targets", "yaml", "readr", "ggplot2"))
# 真实项目再安装 edgeR、DESeq2、limma、clusterProfiler、fgsea、GSVA、decoupleR 等
targets::tar_make()
quarto::quarto_render("analysis/01_qc.qmd")
quarto::quarto_render("analysis/02_differential_expression.qmd")
~~~

真实 count 矩阵和元数据放到 `data/raw/`，并在 `config/project.yml` 改路径。大型文件、未发表数据和敏感数据不提交到 Git。

## 目录

~~~text
.
├─ _targets.R
├─ config/project.yml
├─ data/
│  ├─ mock/counts.csv
│  ├─ mock/sample_metadata.csv
│  └─ raw/                  # 私有输入，默认忽略
├─ R/
│  ├─ 01_import.R
│  ├─ 02_de.R
│  ├─ 03_enrichment.R
│  └─ 04_activity.R
├─ analysis/
│  ├─ 01_qc.qmd
│  └─ 02_differential_expression.qmd
├─ docs/statistical_decisions.md
├─ python/validate_count_matrix.py
├─ renv/README.md
└─ .github/workflows/check.yml
~~~

## 与已有仓库的衔接

- 上游 FASTQ 比对和定量可以使用已有的 [RNA_pipeline](https://github.com/Threezs/RNA_pipeline) 或 nf-core/Nextflow。
- 文献和方法依据放在 [bioinformatics-literature-workbench](https://github.com/Threezs/bioinformatics-literature-workbench)。
- 复用的 R/Python 配方放在 [bioinformatics-methods-cookbook](https://github.com/Threezs/bioinformatics-methods-cookbook)。
- 需要论文级项目管理时，把本仓库内容复制到 [research-compendium-template-r](https://github.com/Threezs/research-compendium-template-r)。

## 参考的成熟项目

- [Bioconductor RNA-seq workflow](https://bioconductor.org/help/workflows/rnaseqGene/)
- [edgeR](https://bioconductor.org/packages/edgeR/)
- [DESeq2](https://bioconductor.org/packages/DESeq2/)
- [limma](https://bioconductor.org/packages/limma/)
- [fgsea](https://bioconductor.org/packages/fgsea/)
- [ropensci/targets](https://github.com/ropensci/targets)
- [nf-core/rnaseq](https://github.com/nf-core/rnaseq)



## 与近期方法目录的关系

这个仓库负责 bulk RNA-seq 的样本级主统计：edgeR QL、DESeq2/limma 敏感性分析、ORA/GSEA、camera/fry/ROAST、PROGENy、GSVA 和 TF activity。近期单细胞、长读长、DTU、空间和 foundation model 方法放在 [nature-methods-bioinformatics-catalog](https://github.com/Threezs/nature-methods-bioinformatics-catalog)。

对 APAP/IR 项目，建议先完成本仓库的 bulk 主分析，再把单细胞或 transcript-level 方法作为补充。不要用 foundation-model embedding 或细胞级概率替代 sample-level DE；模型输出要在 evidence notebook 中单独标记为 support、exploration 或 hypothesis。

## 长读长专题边界

NaRMBench 只适用于 nanopore direct-RNA 修饰检测专题，不能替代 bulk count 的差异表达或 transcript usage 主分析。长读长方法按数据类型选择 Bambu、satuRn 或 NaRMBench，并记录 reference、chemistry 和 biological replicate；不要用 foundation-model embedding、Mellon density、空间 cluster、benchmark 排名或细胞级概率替代 sample-level DE。
