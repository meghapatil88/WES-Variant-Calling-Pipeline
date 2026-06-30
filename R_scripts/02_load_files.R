# 1. load snps annotated file
snps <- read.delim(
  "/Users/meghapatil/WES-analysis/annotation/SRR099968_snps_annotated.txt",
  sep = "\t",
  stringsAsFactors = FALSE,
  skip = 157,  # Skip VEP headers
  header = TRUE)

# 2. load indels annotated file
indels <- read.delim(
  "/Users/meghapatil/WES-analysis/annotation/SRR099968_indels_annotated.txt",
  sep = "\t",
  stringsAsFactors = FALSE,
  skip = 157,
  header = TRUE)

# 3.
cat("SNPs loaded:", nrow(snps), "rows\n")
cat("Indels loaded:", nrow(indels), "rows\n")

# 4. Check columns
cat("\nSNPs columns:\n")
print(names(snps))


