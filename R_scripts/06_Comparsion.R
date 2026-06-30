# SNPs vs Indels Comparsion
comparison_data <- rbind(
  snps %>% filter(!is.na(IMPACT)) %>% select(IMPACT) %>% mutate(Type = "SNPs"),
  indels %>% filter(!is.na(IMPACT)) %>% select(IMPACT) %>% mutate(Type = "Indels")
)

plot_comparison <- comparison_data %>%
  group_by(Type, IMPACT) %>%
  summarise(Count = n(), .groups = "drop") %>%
  ggplot(aes(x = factor(IMPACT, levels = c("HIGH", "MODERATE", "LOW", "MODIFIER")), 
             y = Count, fill = Type)) +
  geom_bar(stat = "identity", position = "dodge", color = "black", width = 0.7) +
  geom_text(aes(label = Count), vjust = -0.5, position = position_dodge(width = 0.7), size = 3.5) +
  scale_fill_manual(
    values = c("SNPs" = "#1f77b4", "Indels" = "#ff7f0e")
  ) +
  labs(
    title = "SNPs vs Indels - Impact Severity Comparison",
    subtitle = "SRR099968 (HG00265, WES)",
    x = "Impact Severity",
    y = "Number of Variants",
    fill = "Variant Type"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 13, face = "bold"),
    plot.subtitle = element_text(size = 10, color = "gray50"),
    axis.title = element_text(size = 11, face = "bold"),
    axis.text = element_text(size = 10),
    legend.position = "top"
  )

