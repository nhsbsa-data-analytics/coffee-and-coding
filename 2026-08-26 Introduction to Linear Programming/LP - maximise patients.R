library(lpSolve)

lp_object <- lp(
  direction = "max",
  
  # Coefficients of the objective function
  objective.in = c(1,1),
  
  # Coefficients of constraints
  const.mat = matrix(c(1,    0.5,
                       0.75, 3,
                       0,    1,
                       1,    0,
                       0,    1),
                     nrow = 5,
                     byrow = TRUE),
  
  # Signs of constraints
  const.dir = c("<=",
                "<=",
                "<=",
                ">=",
                ">="),
  
  # RHSs of constraints
  const.rhs = c(200,
                240,
                40,
                0,
                0),
  
  # Indices of variables are required to be integers
  int.vec = c(1,2)
  
)

lp_object

lp_object$solution
