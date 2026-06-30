# Get the last column name (contains all VEP data)
last_col <- ncol(snps)
extra_col_name <- names(snps)[last_col]

cat("\nExtra column name:", extra_col_name, "\n")

# Extract IMPACT from last column
snps$IMPACT <- str_extract(snps[[last_col]], "IMPACT=([^;]+)") %>% str_remove("IMPACT=")

indels$IMPACT <- str_extract(indels[[last_col]], "IMPACT=([^;]+)") %>% str_remove("IMPACT=")

# Extract SYMBOL too
snps$SYMBOL <- str_extract(snps[[last_col]], "SYMBOL=([^;]+)") %>% str_remove("SYMBOL=")

indels$SYMBOL <- str_extract(indels[[last_col]], "SYMBOL=([^;]+)") %>% str_remove("SYMBOL=")
