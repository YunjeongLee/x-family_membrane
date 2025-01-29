change_unit <- function(params) {
  # Find row having unit of "molecule/cell" ---------------------------------
  idx <- which(rowSums(params == "molecule/cell") > 0)
  
  # Change the unit ---------------------------------------------------------
  avogadro = 6.02214e23;  # molecule/mol
  EC_vol = 1e-12; # liter
  EC_area = 1e-5; # cm2
  for (i in idx) {
    params$value[[i]] <- params$value[[i]] / avogadro / EC_vol
  }

  # Find row having unit of "cm2/mol/s" -------------------------------------
  idx <- which(rowSums(params == "cm2/mol/s") > 0)
  for (i in idx) {
    params$value[[i]] <- params$value[[i]] / EC_area * EC_vol
  }
  
  return(params)
}