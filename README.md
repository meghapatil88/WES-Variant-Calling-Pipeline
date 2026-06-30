# WES Variant Calling & Clinical Prioritization Pipeline

**SRR099968 (HG00265) - 1000 Genomes Project**

A comprehensive Whole Exome Sequencing (WES) analysis pipeline demonstrating end-to-end variant discovery, annotation, and clinical prioritization.

---

## 📋 Project Overview

### Dataset Information
- **Sample:** Coriell HG00265 (British population, GBR)
- **SRA Accession:** SRR099968
- **Sequencing Technology:** Illumina HiSeq 2000
- **Strategy:** Whole Exome Sequencing (WXS)
- **Data Volume:** 89.6M spots, 13.6G bases, 7.9GB
- **Publication Date:** 2011-02-11
- **Source:** 1000 Genomes Project

---

## 🎯 Key Findings

### Variant Summary

| Metric | Count | Percentage |
|--------|-------|-----------|
| **Total Variants** | 29,481 | 100% |
| **SNPs** | 27,694 | 94.0% |
| **Indels** | 1,787 | 6.0% |

### Impact Distribution

| Impact Level | SNPs | Indels | Total | Percentage |
|---|---|---|---|---|
| **HIGH** | 75 | 18 | **93** | **0.3%** |
| **MODERATE** | 1,678 | 5 | **1,683** | **5.7%** |
| **LOW** | 2,287 | 74 | **2,361** | **8.0%** |
| **MODIFIER** | 23,654 | 1,690 | **25,344** | **86.0%** |

### High-Confidence Variants

- **Total HIGH impact variants after filtering:** `72`
- **SNPs with HIGH impact:** `57`
- **Indels with HIGH impact:** `15`
- **Novel variants (Not in gnomAD):** `72 (100%)`

### Most Damaging Consequence Types

| Consequence | Count | Impact |
|---|---|---|
| **stop_gained** | 37 | Premature termination → Truncated protein |
| **frameshift_variant** | 14 | Reading frame shift → Non-functional protein |
| **splice_site_variant** | 10 | Splicing disruption → No functional transcript |
| **splice_donor_variant** | 7 | Donor site disruption → Exon skipping |
| **stop_lost** | 4 | Stop codon loss → Extended protein |

---

## 🔬 Analysis Pipeline

### Step 1: Quality Control
```
Tool: FastQC
Input: Raw FASTQ reads (89.6M spots)
Output: Quality reports
Assessment: Per-base quality, adapter content, GC bias
```

### Step 2: Read Trimming
```
Tool: Trimmomatic
Filters:
  • Remove Illumina adapters (TruSeq3-PE.fa)
  • Remove leading/trailing bases with QUAL < 3
  • Sliding window (4bp, QUAL < 15)
  • Minimum read length: 50bp
Output: Cleaned paired-end reads
```

### Step 3: Reference Preparation
```
Tool: BWA, SAMtools, Picard
Reference: hg38 (GRCh38)
Indexing: BWA index, SAMtools faidx, Picard dictionary
Output: Indexed reference genome for alignment
```

### Step 4: Sequence Alignment
```
Tool: BWA-MEM
Reference: hg38 (GRCh38)
Parameters:
  • Threads: 8
  • Read groups: Added for GATK compatibility
Output: Sorted, indexed BAM file
Mapped reads: 89.6M
```

### Step 5: Duplicate Marking
```
Tool: Picard MarkDuplicates
Purpose: Flag PCR duplicates
Output: BAM with duplicate markers
Metrics: Duplication statistics
```

### Step 6: Variant Calling
```
Tool: GATK HaplotypeCaller
Reference: hg38
Output: VCF format
Variants called: 29,481
Known variants checked against: dbSNP
```

### Step 7: Variant Filtering
```
Tool: bcftools
Quality Filters:
  • QUAL > 30 (Phred quality score)
  • DP > 10 (minimum depth)
  • DP < 500 (maximum depth, removes artifacts)
  • MQ > 40 (mapping quality)
Output: High-confidence VCF
```

### Step 8: Functional Annotation
```
Tool: Ensembl VEP v105.0
Reference: GRCh38
Annotations:
  • Consequence predictions
  • Impact severity classification
  • Population frequencies (gnomAD)
Output: VEP-annotated VCF
```

---

## 📂 Repository Structure

```
WES-Variant-Calling-SRR099968/
│
├── README.md
├── .gitignore
├── data/
├── trimmed/
├── reference/
├── alignment/
├── variants/
├── annotation/
├── filtered_variants/
├── results/
├── figures/
├── plots/
├── logs/
├── scripts/
└── R_scripts/
```

---

## 🛠️ Tools & Technologies

### Sequence Analysis
- **FastQC** v0.11+ — Quality control
- **Trimmomatic** v0.39+ — Adapter/quality trimming
- **BWA-MEM** v0.7.17+ — Read alignment
- **SAMtools** v1.14+ — BAM manipulation
- **Picard** v2.26+ — Duplicate marking
- **GATK4** v4.2+ — Variant calling

### Variant Processing
- **bcftools** v1.14+ — VCF filtering
- **Ensembl VEP** v105.0 — Functional annotation
- **gnomAD database** — Population frequencies

### Data Analysis & Visualization
- **R** v4.0+ — Statistical analysis
- **ggplot2** — Publication-quality plots
- **tidyverse** — Data manipulation
- **stringr** — String processing
- **gridExtra** — Plot composition

---

## 📊 Visualizations

### Impact Distribution Plots
- **SNP Impact Distribution** - Shows 75 HIGH impact SNPs across all consequence types

<img width="2400" height="1500" alt="Image" src="https://github.com/user-attachments/assets/742fcebe-7094-4589-b9c1-2a4883bd833a" />

---

- **Indel Impact Distribution** - Shows 18 HIGH impact Indels with higher severity proportion

<img width="2400" height="1500" alt="Image" src="https://github.com/user-attachments/assets/5cbd9af7-7a4b-431f-b372-ada7f1695929" />

---

- **SNPs vs Indels Comparison** - Comparative analysis showing variant type patterns

<img width="3000" height="1800" alt="Image" src="https://github.com/user-attachments/assets/6b06e03c-c3a6-4b04-913d-62ac434c888b" />

---

### High-Confidence Variant Analysis

- **Consequence Type Distribution** - 37 stop_gained mutations are most common and damaging

  <img width="2400" height="1500" alt="Image" src="https://github.com/user-attachments/assets/3000c960-88f8-4772-962e-5f3e56831f81" />

  ---
  
- **Population Frequency Status** - **72 variants NOT in gnomAD (100% novel)**

- <img width="2400" height="1500" alt="Image" src="https://github.com/user-attachments/assets/f1762d6d-3fb7-4db5-a10b-0815c8cc6d40" />

---

- **SNP vs Indel Breakdown** - 57 SNPs + 15 Indels = all novel variants

- <img width="3000" height="1800" alt="Image" src="https://github.com/user-attachments/assets/5e5261d1-19ce-4f83-ba68-1f7318e9e3a3" />

---

## 🔍 Clinical Significance

### Why These Variants Matter

**All 72 HIGH impact variants are NOVEL:**
- Never observed in 125,000+ healthy individuals (gnomAD database)
- Never reported in public sequence databases
- Extremely rare in human population
- **High likelihood of pathogenicity**

### Consequence Type Interpretation

| Type | Mechanism | Outcome |
|---|---|---|
| **stop_gained** | Creates premature stop codon | Protein truncation → Loss of function |
| **frameshift_variant** | Insertion/deletion shifts reading frame | Wrong amino acids → Non-functional protein |
| **splice_site_variant** | Disrupts splice sites | Exon skipping or intron retention |
| **splice_donor_variant** | Mutates donor site (GT at intron start) | Exon skipping → No functional transcript |
| **stop_lost** | Converts stop codon to sense codon | Extended protein with unknown effects |

---

## 👤 Author

**Megha Patil**
- MSc Biotechnology (Bioinformatics)
- NGS Analysis | Variant Calling | Genomics
- GitHub: [@meghapatil88](https://github.com/meghapatil88)
- Location: Bengaluru, India

---

## 📄 License

MIT License - This project is open source and available for educational and research purposes.

---

## 🔗 Related Projects

- [WGS Variant Calling Pipeline](https://github.com/meghapatil88/WGS-Variant-Calling-Pipeline) (SRR062634) — Complete genome analysis

---

**Analysis completed:** June 2026  
**Last updated:** June 30, 2026
