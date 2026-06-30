# Indels Impact Distribution
plot_indels <- indels %>%
  filter(!is.na(IMPACT)) %>%
  group_by(IMPACT) %>%
  summarise(Count = n(), .groups = "drop") %>%
  ggplot(aes(x = factor(IMPACT, levels = c("HIGH", "MODERATE", "LOW", "MODIFIER")), 
             y = Count, fill = IMPACT)) +
  geom_bar(stat = "identity", color = "black", width = 0.6) +
  geom_text(aes(label = Count), vjust = -0.5, size = 4, fontface = "bold") +
  scale_fill_manual(
    values = c("HIGH" = "#d62728", "MODERATE" = "#ff7f0e", 
               "LOW" = "#2ca02c", "MODIFIER" = "#1f77b4"),
    guide = "none"
  ) +
  labs(
    title = "Indels - Impact Distribution",
    subtitle = "SRR099968 (HG00265, WES)",
    x = "Impact Severity",
    y = "Number of Variants"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 13, face = "bold"),
    plot.subtitle = element_text(size = 10, color = "gray50"),
    axis.title = element_text(size = 11, face = "bold"),
    axis.text = element_text(size = 10)
  )
