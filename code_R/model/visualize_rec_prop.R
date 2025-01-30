visualize_rec_prop <- function(results, result_foldername) {
  # Define colors -----------------------------------------------------------
  colors = c('#eac435', '#345995')
  color_lig = c('#ff595e', '#ff924c', '#ffca3a', '#8ac926', '#1982c4', '#6a4c93')
  
  # Calculate the percentage of free vs. bound receptors --------------------
  rec = c('VEGFR1', 'VEGFR2', 'NRP1', '$PDGFR\\alpha$', '$PDGFR\\beta$')
  rec_result = c('R1', 'R2', 'N1', 'PDRa', 'PDRb')
  
  df <- data.frame(matrix(ncol = 3, nrow=0))
  for (i in 1:length(rec_result)) {
    rec_name = rec[i]
    rec_result_name = rec_result[i]
    # Free ligand
    FreeColName = paste0(rec_result_name, '_free')
    # Bound ligand
    BoundColName = paste0(rec_result_name, '_bound')
    # Calculate the percentage of free and bound ligand
    value <- unname(
      tail(results[c(FreeColName, BoundColName)], 1)
      /sum(tail(results[c(FreeColName, BoundColName)], 1))
    )
    # Record
    new_df <- data.frame(Receptor=rep(rec_name, 2), 
                         Status=c('Free', 'Bound'), 
                         Value=as.vector(t(value)), 
                         row.names = NULL)
    # Append df
    df <- rbind(df, new_df)
  }
  # Fix the order of row
  df$Receptor <- factor(df$Receptor, levels=rec)
  
  # Plot the bar graph ------------------------------------------------------
  p = df %>% 
    mutate(percent_labels = scales::percent(Value, accuracy=1)) %>% 
    ggplot(aes(x = Receptor, y = Value, fill = Status)) +
    geom_col() +
    geom_text(
      aes(label = percent_labels), 
      position = position_stack(vjust = 0.5)
    ) + 
    scale_x_discrete(labels = function(x) TeX(x)) +
    scale_y_continuous(labels = scales::percent_format()) +
    scale_fill_manual(values=colors) +
    labs(x = "Receptor", y = "Percentage (%)") +
    theme(text = element_text(size= 10)) + theme_light()
  show(p)
  ggsave(sprintf("%s/Receptor_free_vs_bound.pdf", result_foldername), width = 6, height = 3, units = "in")
}