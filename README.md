# RNA-seq Analysis Template

这个仓库负责 bulk RNA-seq 的样本级主统计：edgeR QL、DESeq2/limma 敏感性分析、ORA/GSEA、camera/fry/ROAST、PROGENy、GSVA 和 TF activity。近期单细胞、长读长、DTU、空间和 foundation model 方法放在 [nature-methods-bioinformatics-catalog](https://github.com/Threezs/nature-methods-bioinformatics-catalog)。

## 与近期方法目录的关系

对 APAP/IR 项目，建议先完成本仓库的 bulk 主分析，再把单细胞或 transcript-level 方法作为补充。不要用 foundation-model embedding、Mellon density、空间 cluster、benchmark 排名或细胞级概率替代 sample-level DE；模型输出要在 evidence notebook 中单独标记为 support、exploration 或 hypothesis。

NaRMBench 只适用于 nanopore direct-RNA 修饰检测专题，不能替代 bulk count 的差异表达或 transcript usage 主分析。长读长方法仍要按数据类型选择 Bambu、satuRn 或 NaRMBench，并记录 reference、chemistry 和 biological replicate。
