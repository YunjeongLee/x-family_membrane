visualize_lig_prop <- function(results, result_foldername) {
  # Define colors -----------------------------------------------------------
  colors = c('#eac435', '#345995')
  
  # Calculate the percentage of free vs. bound ligand -----------------------
  lig = c('VEGF-A', 'VEGF-B', 'PlGF', 'PDGF-AA', 'PDGF-AB', 'PDGF-BB')
  lig_result = c('VA', 'VB', 'Pl', 'PDAA', 'PDAB', 'PDBB')
  
  df <- data.frame(matrix(ncol=3, nrow=0))
  colnames(df) <- c('Ligand', 'Status', 'Value')
  for (i in 1:length(lig)) {
    lig_name = lig[i]
    lig_result_name = lig_result[i]
    # Free ligand
    FreeColName = paste0(lig_result_name, '_free')
    # Bound ligand
    BoundColName = paste0(lig_result_name, '_bound')
    # Calculate the percentage of free and bound ligand
    value <- unname(
      tail(results[c(FreeColName, BoundColName)], 1)
      /sum(tail(results[c(FreeColName, BoundColName)], 1))
    )
    # Record
    new_df <- data.frame(Ligand=rep(lig_name, 2), 
                         Status=c('Free', 'Bound'), 
                         Value=as.vector(t(value)), 
                         row.names = NULL)
    # Append df
    df <- rbind(df, new_df)
  }
  # Fix the order of row
  df$Ligand <- factor(df$Ligand, levels=lig)

  # Plot the bar graph ------------------------------------------------------
  p = df %>% 
    mutate(percent_labels = scales::percent(Value, accuracy=1)) %>% 
    ggplot(aes(x = Ligand, y = Value, fill = Status)) +
    geom_col() +
    geom_text(
      aes(label = percent_labels), 
      position = position_stack(vjust = 0.5)
    ) + 
    scale_y_continuous(labels = scales::percent_format()) +
    scale_fill_manual(values=colors) +
    labs(x = "Ligand", y = "Percentage (%)") +
    theme(text = element_text(size= 10)) + theme_light()
  show(p)
  ggsave(sprintf("%s/Ligand_free_vs_bound.pdf", result_foldername), width = 6, height = 3, units = "in")
}