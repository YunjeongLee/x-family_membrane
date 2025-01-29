assign_params <- function(params) {
  for (i in 1:nrow(params)) {
    name <- params$Parameter[i]
    value <- params$value[i]
    assign(x=name, value=value, envir = .GlobalEnv)
  }
}