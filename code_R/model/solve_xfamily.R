solve_xfamily <- function(params, y0, time_stamp) {
  # Solve ODE system --------------------------------------------------------
  # The number of species
  n = 30
  
  # Set ode solver option
  absTol = 1e-20
  relTol = 1e-9
  
  # Solve ODE system
  results <- ode(y0, time_stamp, func=ode_xfamily, parms=params,
                 method="radau", rtol=relTol, atol=absTol)
  
  sol = data.frame(results)
  
  # Calculate free ligand concentration -------------------------------------
  sol$VA_free = sol$VA
  sol$VB_free = sol$VB
  sol$Pl_free = sol$Pl
  sol$PDAA_free = sol$PDAA
  sol$PDAB_free = sol$PDAB
  sol$PDBB_free = sol$PDBB
  
  # Calculate receptor bound ligand -----------------------------------------
  idx_VA   = which(str_detect(colnames(sol), "VA_") & !str_detect(colnames(sol), "_free"))
  idx_VB   = which(str_detect(colnames(sol), "VB_") & !str_detect(colnames(sol), "_free"))
  idx_Pl   = which(str_detect(colnames(sol), "Pl_") & !str_detect(colnames(sol), "_free"))
  idx_PDAA = which(str_detect(colnames(sol), "PDAA_") & !str_detect(colnames(sol), "_free"))
  idx_PDAB = which(str_detect(colnames(sol), "PDAB_") & !str_detect(colnames(sol), "_free"))
  idx_PDBB = which(str_detect(colnames(sol), "PDBB_") & !str_detect(colnames(sol), "_free"))
  
  sol$VA_bound   = rowSums(sol[idx_VA])
  sol$VB_bound   = rowSums(sol[idx_VB])
  sol$Pl_bound   = rowSums(sol[idx_Pl])
  sol$PDAA_bound = rowSums(sol[idx_PDAA])
  sol$PDAB_bound = rowSums(sol[idx_PDAB])
  sol$ PDBB_bound = rowSums(sol[idx_PDBB])
  
  # Calculate free receptors ------------------------------------------------
  sol$R1_free = sol$R1 + sol$R1_N1
  sol$R2_free = sol$R2
  sol$N1_free = sol$N1 + sol$R1_N1
  sol$PDRa_free = sol$PDRa
  sol$PDRb_free = sol$PDRb
  
  # Calculate bound receptors -----------------------------------------------
  idx_R1   = which(str_detect(colnames(sol), "_R1"))
  idx_R2   = which(str_detect(colnames(sol), "_R2"))
  idx_N1   = which(str_detect(colnames(sol), "_N1") & !str_detect(colnames(sol), "R1_N1"))
  idx_PDRa = which(str_detect(colnames(sol), "_PDRa"))
  idx_PDRb = which(str_detect(colnames(sol), "_PDRb"))
  
  sol$R1_bound   = rowSums(sol[idx_R1])
  sol$R2_bound   = rowSums(sol[idx_R2])
  sol$N1_bound   = rowSums(sol[idx_N1])
  sol$PDRa_bound = rowSums(sol[idx_PDRa])
  sol$PDRb_bound = rowSums(sol[idx_PDRb])
  
  return(sol)
  
}