visualize_dynamics <- function(time_stamp, results, result_foldername) {
  # Define colors -----------------------------------------------------------
  color_lig = c('#ff595e', '#ff924c', '#ffca3a', '#8ac926', '#1982c4', '#6a4c93')
  color_rec = c('#8ecae6', '#219ebc', '#023047', '#ffb703', '#fb8500')
  
  # Define list of ligands and receptors ------------------------------------
  lig = c('VEGF-A', 'VEGF-B', 'PlGF', 'PDGF-AA', 'PDGF-AB', 'PDGF-BB')
  lig_result = c('VA', 'VB', 'Pl', 'PDAA', 'PDAB', 'PDBB')
  rec = c('VEGFR1', 'VEGFR2', 'NRP1', expression(PDGFR*alpha), expression(PDGFR*beta))
  rec_result = c('R1', 'R2', 'N1', 'PDRa', 'PDRb')
  
  # Generate free vs. bound ligand data -------------------------------------
  df <- data.frame(matrix(ncol=0, nrow=length(results$time)))
  for (i in 1:length(lig)) {
    lig_name = lig[i]
    lig_result_name = lig_result[i]
    # Free ligand
    colName = paste(lig_name, '(Free)')
    colName_results = paste0(lig_result_name, '_free')
    df[[colName]] <- results[[colName_results]] * 1e12
    # Bound ligand
    colName = paste(lig_name, '(Bound)')
    colName_results = paste0(lig_result_name, '_bound')
    df[[colName]] <- results[[colName_results]] * 1e12
  }
  df_colnames = colnames(df)
  df$time <- results$time
  df <- pivot_longer(df, cols = -time,
                     names_to = "variable", values_to = "value")
  df$variable <- factor(df$variable, levels=df_colnames)
  
  # Plot free vs. bound ligand ----------------------------------------------
  df$colors = rep(rep(color_lig, each=2), length(results$time))
  df$linestyle = rep(c("solid", "dotted"), length(results$time) * length(color_lig))
  p = ggplot(data = df, aes(x = time/3600, y = value, color = variable, linetype = variable)) +
    geom_line(linewidth = 1) +
    scale_colour_manual(values=df$colors) +
    scale_linetype_manual(values=df$linestyle) +
    labs(x = "Time (hour)", y = "Concentration (pM)") +
    theme(text = element_text(size= 10)) +
    scale_y_continuous(breaks = seq(0, 1200, 200), labels = seq(0, 1200, 200)) + 
    theme_light()
  ggsave(sprintf("%s/dynamics_free_vs_bound_lig.pdf", result_foldername), width = 6, height = 3, units = "in")
  
  # Generate free vs. bound receptor data -----------------------------------
  df <- data.frame(matrix(ncol=0, nrow=length(results$time)))
  for (i in 1:length(lig)) {
    rec_name = rec[i]
    rec_result_name = rec_result[i]
    # Free receptor
    colName = paste(rec_name, '(Free)')
    colName_results = paste0(rec_result_name, '_free')
    df[[colName]] <- results[[colName_results]] * 1e12
    # Bound ligand
    colName = paste(rec_name, '(Bound)')
    colName_results = paste0(rec_result_name, '_bound')
    df[[colName]] <- results[[colName_results]] * 1e12
  }
  df_colnames = colnames(df)
  df$time <- results$time
  df <- pivot_longer(df, cols = -time,
                     names_to = "variable", values_to = "value")
  df$variable <- factor(df$variable, levels=df_colnames)
  
}