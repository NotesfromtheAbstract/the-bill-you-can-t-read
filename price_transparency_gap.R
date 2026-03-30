# ============================================================
# What Hospitals Bill vs. What Medicare Actually Pays
# Notes from the Abstract — The Bill You Can't Read
# A. Rupert Crocker
# Source: CMS Medicare Inpatient Hospitals by Provider and Service, FY 2023
# ============================================================

library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)

theme_1950s <- function() {
  theme_minimal(base_family = "Arial", base_size = 14) +
    theme(
      plot.background    = element_rect(fill = "#FAF5E9", color = NA),
      panel.background   = element_rect(fill = "#FAF5E9", color = NA),
      panel.grid.major   = element_line(color = "#E6DECA", linewidth = 0.6),
      panel.grid.minor   = element_blank(),
      axis.title         = element_text(face = "bold", color = "#3A3A3A"),
      axis.text          = element_text(color = "#4A4A4A"),
      plot.title         = element_text(face = "bold", size = 20, color = "#3A3A3A"),
      plot.subtitle      = element_text(size = 11, color = "#5A5A5A"),
      plot.margin        = margin(15, 20, 15, 15),
      legend.position    = "none"
    )
}

drg_data <- tribble(
  ~drg, ~label,                                ~charge,  ~total_pymt,
  690,  "Kidney & UTI\n(DRG 690)",              35026,    7481,
  603,  "Cellulitis\n(DRG 603)",                35047,    8208,
  392,  "Esophagitis & GI\n(DRG 392)",          37534,    7500,
  291,  "Heart Failure\n(DRG 291)",             49752,    11548,
   65,  "Intracranial Hem.\n(DRG 65)",          52757,    9482,
  193,  "Simple Pneumonia\n(DRG 193)",          54043,    11527,
  177,  "Resp. Infections\n(DRG 177)",          62325,    15986,
  871,  "Septicemia\n(DRG 871)",                74731,    17235,
  470,  "Hip & Knee Replace.\n(DRG 470)",       87838,    16458,
  483,  "Back & Neck Proc.\n(DRG 483)",        111791,    20519,
  247,  "Percutaneous\nCardiovasc. (DRG 247)", 112338,    17170,
  460,  "Spinal Fusion\n(DRG 460)",            158444,    32881
) %>%
  mutate(
    ratio = round(charge / total_pymt, 1),
    label = factor(label, levels = label)
  )

plot_data <- drg_data %>%
  pivot_longer(
    cols      = c(charge, total_pymt),
    names_to  = "measure",
    values_to = "amount"
  ) %>%
  mutate(
    measure = factor(
      measure,
      levels = c("charge", "total_pymt"),
      labels = c("Chargemaster (Submitted Charge)", "Total Medicare Payment")
    )
  )

pal <- c(
  "Chargemaster (Submitted Charge)" = "#C0392B",
  "Total Medicare Payment"          = "#2471A3"
)

p <- ggplot(plot_data, aes(x = label, y = amount, fill = measure)) +
  geom_col(
    position = position_dodge(width = 0.68),
    width    = 0.60,
    alpha    = 0.91
  ) +
  geom_text(
    data        = drg_data,
    aes(x       = label, y = charge,
        label   = paste0(ratio, "\u00d7"),
        fill    = NULL),
    position    = position_nudge(x = -0.17),
    vjust       = -0.45,
    hjust       = 0.5,
    size        = 4.0,
    color       = "#C0392B",
    fontface    = "bold",
    inherit.aes = FALSE
  ) +
  scale_y_continuous(
    labels = label_dollar(scale = 1e-3, suffix = "K"),
    expand = expansion(mult = c(0, 0.14))
  ) +
  scale_fill_manual(values = pal, name = NULL) +
  labs(
    title    = "What Hospitals Bill vs. What Medicare Actually Pays",
    subtitle = "National average submitted charges vs. total Medicare payment by MS-DRG \u00b7 FY 2023\nRed ratio labels = submitted charge \u00f7 total payment.",
    x        = NULL,
    y        = "Average Amount (USD)",
    caption  = "Source: CMS Medicare Inpatient Hospitals by Provider and Service, FY 2023. Averages computed across all reporting hospitals nationally.\nChargemaster figures represent gross submitted charges prior to any contractual adjustment, discount, or payer negotiation."
  ) +
  theme_1950s() +
  theme(
    legend.position    = "top",
    legend.text        = element_text(size = 12, color = "#3A3A3A"),
    legend.key.size    = unit(1.0, "lines"),
    legend.spacing.x   = unit(0.4, "cm"),
    axis.text.x        = element_text(angle = 38, hjust = 1, size = 10.5,
                                      lineheight = 1.2),
    panel.grid.major.x = element_blank(),
    plot.subtitle      = element_text(size = 11, color = "#5A5A5A",
                                      lineheight = 1.5),
    plot.caption       = element_text(size = 9, color = "#6A6A6A", hjust = 0,
                                      lineheight = 1.4, margin = margin(t = 10))
  )

# 16:9 at Substack width (1456px wide)
ggsave(
  "/mnt/user-data/outputs/price_transparency_gap.png",
  plot   = p,
  width  = 1456,
  height = 819,
  units  = "px",
  dpi    = 150,
  bg     = "#FAF5E9"
)

cat("Saved.\n")
