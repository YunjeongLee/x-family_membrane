# Clear all ---------------------------------------------------------------
# Clear plots
if (!is.null(dev.list())) dev.off()
# Clear console
cat("\014")
# Clear workspace
rm(list = ls())

# Change working directory ------------------------------------------------
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Add path ----------------------------------------------------------------
subfolders = c("etc", "model", "visualize")
for (i in 1:length(subfolders)) {
  a = list.files(path = subfolders[i], pattern = "[.]R$", full.names = TRUE)
  for (j in 1:length(a)) {
    source(a[j])
  }
}

# Load libraries ----------------------------------------------------------
pckg_list = c("deSolve", "stringr", "ggplot2", "tidyr", "tidyverse", "latex2exp")
instant_pkgs(pckg_list)

# Load parameters ---------------------------------------------------------
filename = '../data/parameters.csv'
params <- read.csv(filename)

# Change unit of parameters -----------------------------------------------
params <- change_unit(params)

# Change dataframe to a named vector --------------------------------------
y0 <- setNames(params$value[1:30], params$Parameter[1:30])
params_vec <- setNames(params$value[-1:-30], params$Parameter[-1:-30])

# Solve ODE system --------------------------------------------------------
time_stamp <- seq(0, (3600*24*10), 1000)
results <- solve_xfamily(params_vec, y0, time_stamp)

# Visualization -----------------------------------------------------------
results_path = "results/default/"

# Generate new results folder
dir.create(results_path, recursive = TRUE)

visualize_dynamics(time_stamp, results, results_path)
visualize_lig_prop(results, results_path)
visualize_rec_prop(results, results_path)
