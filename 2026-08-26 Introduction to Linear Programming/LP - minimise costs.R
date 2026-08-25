library(lpSolve)

lp_object <- lp(
  direction = "min",
  
  # Coefficients of the objective function
  objective.in = c(140,240,200,340),
  
  # Coefficients of constraints
  const.mat = matrix(c(1,    1,     0,    0,
                       0,    0,     1,    1,
                   -0.15, 0.85,     0,    0,
                       0,    0, -0.15, 0.85,
                       1,    0,     1,    0,
                       1,    0,     0,    0,
                       0,    1,     0,    0,
                       0,    0,     1,    0,
                       0,    0,     0,    1),
                     nrow = 9,
                     byrow = TRUE),
  
  # Signs of constraints
  const.dir = rep(">=", 9),
  
  # RHSs of constraints
  const.rhs = c(20,
                12,
                0,
                0,
                30,
                0,
                0,
                0,
                0),
  
  # Indices of variables are required to be integers
  int.vec = c(1,2,3,4)
  
)

lp_object

lp_object$solution
