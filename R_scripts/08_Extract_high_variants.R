library(tidyverse)

# 1: Extract HIGH variants separately
# Get the extra column indices
snps_extra_idx <- ncol(snps)
indels_extra_idx <- ncol(indels)

# Extract HIGH from SNPs
high_snps <- snps %>%
  filter(IMPACT == "HIGH") %>%
  mutate(
    Variant_Type = "SNP"
  )

# Extract HIGH from Indels
high_indels <- indels %>%
  filter(IMPACT == "HIGH") %>%
  mutate(
    Variant_Type = "Indel"
  )

cat("===== HIGH IMPACT VARIANTS =====\n")
cat("SNPs with HIGH impact:", nrow(high_snps), "\n")
cat("Indels with HIGH impact:", nrow(high_indels), "\n")

# 2: Extract fields from SNPs

high_snps$GENE <- str_extract(high_snps[[snps_extra_idx]], "SYMBOL=([^;]+)") %>% 
  str_remove("SYMBOL=")

high_snps$CONSEQUENCE <- high_snps[[7]]

high_snps$GNOMAD_AF <- str_extract(high_snps[[snps_extra_idx]], "gnomAD_AF=([^;]+)") %>% 
  str_remove("gnomAD_AF=")

high_snps$AF <- str_extract(high_snps[[snps_extra_idx]], "AF=([^;]+)") %>% 
  str_remove("AF=")

high_snps$CANONICAL <- str_extract(high_snps[[snps_extra_idx]], "CANONICAL=([^;]+)") %>% 
  str_remove("CANONICAL=")

high_snps$BIOTYPE <- str_extract(high_snps[[snps_extra_idx]], "BIOTYPE=([^;]+)") %>% 
  str_remove("BIOTYPE=")

# 3: Extract fields from Indels
high_indels$GENE <- str_extract(high_indels[[indels_extra_idx]], "SYMBOL=([^;]+)") %>% 
  str_remove("SYMBOL=")

high_indels$CONSEQUENCE <- high_indels[[7]]

high_indels$GNOMAD_AF <- str_extract(high_indels[[indels_extra_idx]], "gnomAD_AF=([^;]+)") %>% 
  str_remove("gnomAD_AF=")

high_indels$AF <- str_extract(high_indels[[indels_extra_idx]], "AF=([^;]+)") %>% 
  str_remove("AF=")

high_indels$CANONICAL <- str_extract(high_indels[[indels_extra_idx]], "CANONICAL=([^;]+)") %>% 
  str_remove("CANONICAL=")

high_indels$BIOTYPE <- str_extract(high_indels[[indels_extra_idx]], "BIOTYPE=([^;]+)") %>% 
  str_remove("BIOTYPE=")

# 4: Create clean dataframe with selected columns
high_snps_clean <- high_snps %>%
  select(Variant_Type, GENE, CONSEQUENCE, GNOMAD_AF, AF, CANONICAL, BIOTYPE, IMPACT)

high_indels_clean <- high_indels %>%
  select(Variant_Type, GENE, CONSEQUENCE, GNOMAD_AF, AF, CANONICAL, BIOTYPE, IMPACT)

# Now combine
high_variants <- rbind(high_snps_clean, high_indels_clean)

cat("\nTotal HIGH impact variants:", nrow(high_variants), "\n")

# 5: Show consequence types
cat("\n===== CONSEQUENCE TYPES =====\n")
print(table(high_variants$CONSEQUENCE))

# 6: Quality filtering
high_confidence <- c(
  "frameshift_variant",
  "stop_gained",
  "stop_lost",
  "splice_acceptor_variant",
  "splice_donor_variant",
  "start_lost"
)

high_filtered <- high_variants %>%
  filter(CONSEQUENCE %in% high_confidence) %>%
  filter(BIOTYPE == "protein_coding" | is.na(BIOTYPE)) %>%
  filter(CANONICAL == "YES" | is.na(CANONICAL))

cat("\n===== AFTER QUALITY FILTERING =====\n")
cat("High confidence variants:", nrow(high_filtered), "\n")
cat("Removed:", nrow(high_variants) - nrow(high_filtered), "\n")

# 7: Prioritize by frequency
high_filtered$GNOMAD_AF_NUM <- as.numeric(high_filtered$GNOMAD_AF)

high_filtered <- high_filtered %>%
  mutate(
    Frequency_Status = case_when(
      is.na(GNOMAD_AF_NUM) ~ "Not_in_gnomAD",
      GNOMAD_AF_NUM == 0 ~ "Novel",
      GNOMAD_AF_NUM < 0.01 ~ "Rare",
      TRUE ~ "Common"
    ),
    Priority = case_when(
      is.na(GNOMAD_AF_NUM) ~ 1,
      GNOMAD_AF_NUM == 0 ~ 1,
      GNOMAD_AF_NUM < 0.01 ~ 2,
      TRUE ~ 3
    )
  ) %>%
  arrange(Priority, GNOMAD_AF_NUM)

# 8: Results

cat("\n===== PRIORITY BREAKDOWN =====\n")
print(table(high_filtered$Priority, high_filtered$Frequency_Status))

cat("\n===== TOP 20 CANDIDATE VARIANTS =====\n")
print(head(high_filtered %>% select(Variant_Type, GENE, CONSEQUENCE, Frequency_Status, GNOMAD_AF_NUM, Priority), 20))
