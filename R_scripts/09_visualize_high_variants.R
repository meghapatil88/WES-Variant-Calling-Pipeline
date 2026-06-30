# 1: HIGH Impact Variants by Consequence Type
plot1 <- high_filtered %>%
  group_by(CONSEQUENCE) %>%
  summarise(Count = n(), .groups = "drop") %>%
  arrange(desc(Count)) %>%
  ggplot(aes(x = reorder(CONSEQUENCE, -Count), y = Count, fill = CONSEQUENCE)) +
  geom_bar(stat = "identity", color = "black", width = 0.7) +
  geom_text(aes(label = Count), vjust = -0.5, size = 3.5, fontface = "bold") +
  scale_fill_brewer(palette = "Set2", guide = "none") +
  labs(
    title = "HIGH Impact Variants by Consequence Type",
    x = "Consequence",
    y = "Count"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 13, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 9),
    axis.title = element_text(size = 11, face = "bold")
  )

# 2: Frequency Status Distribution
plot2 <- high_filtered %>%
  group_by(Frequency_Status) %>%
  summarise(Count = n(), .groups = "drop") %>%
  ggplot(aes(x = factor(Frequency_Status, 
                        levels = c("Not_in_gnomAD", "Novel", "Rare", "Common")), 
             y = Count, fill = Frequency_Status)) +
  geom_bar(stat = "identity", color = "black", width = 0.6) +
  geom_text(aes(label = Count), vjust = -0.5, size = 4, fontface = "bold") +
  scale_fill_manual(
    values = c("Not_in_gnomAD" = "#d62728", "Novel" = "#ff7f0e", 
               "Rare" = "#2ca02c", "Common" = "#1f77b4"),
    guide = "none"
  ) +
  labs(
    title = "HIGH Impact Variants by Population Frequency",
    subtitle = "Novel/Not in gnomAD = Higher priority for clinical follow-up",
    x = "Frequency Status",
    y = "Number of Variants"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 13, face = "bold"),
    plot.subtitle = element_text(size = 10, color = "gray50"),
    axis.title = element_text(size = 11, face = "bold"),
    axis.text = element_text(size = 10)
  )

# 3: SNPs vs Indels in HIGH Impact
plot3 <- high_filtered %>%
  group_by(Variant_Type, Frequency_Status) %>%
  summarise(Count = n(), .groups = "drop") %>%
  ggplot(aes(x = factor(Frequency_Status, 
                        levels = c("Not_in_gnomAD", "Novel", "Rare", "Common")), 
             y = Count, fill = Variant_Type)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", width = 0.7) +
  geom_text(aes(label = Count), vjust = -0.5, position = position_dodge(width = 0.7), size = 3.5) +
  scale_fill_manual(
    values = c("SNP" = "#1f77b4", "Indel" = "#ff7f0e")
  ) +
  labs(
    title = "HIGH Impact SNPs vs Indels by Frequency",
    x = "Frequency Status",
    y = "Count",
    fill = "Variant Type"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 13, face = "bold"),
    axis.title = element_text(size = 11, face = "bold"),
    axis.text.x = element_text(angle = 30, hjust = 1, size = 9),
    legend.position = "top"
  )

# : Summary Statistics Box
summary_text <- paste0(
  "HIGH IMPACT VARIANT SUMMARY\n\n",
  "Total Filtered: ", nrow(high_filtered), " variants\n",
  "Priority 1 (Novel): ", sum(high_filtered$Priority == 1), " variants\n",
  "Priority 2 (Rare): ", sum(high_filtered$Priority == 2), " variants\n",
  "Priority 3 (Common): ", sum(high_filtered$Priority == 3), " variants\n\n",
  "Most Common Consequence:\n", 
  names(table(high_filtered$CONSEQUENCE))[which.max(table(high_filtered$CONSEQUENCE))], "\n\n",
  "Top Affected Gene:\n",
  top_genes$GENE[1], " (", top_genes$Count[1], " variants)"
)

plot 4 <- ggplot() +
  annotate("text", x = 0.5, y = 0.5, label = summary_text,
           size = 5, hjust = 0.5, vjust = 0.5, family = "monospace",
           color = "black") +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "#f0f0f0", color = "black", size = 2)
  )

