library(lpSolve)

lp_object <- lp(
  direction = "max",
  
  # Coefficients of the objective function
  objective.in = c(0,0,0,1),
  
  # Coefficients of constraints
  const.mat = matrix(c(5,   4,  6.5, -1,
                       0,   7,  3,   -1,
                       2.5, 6,  4,   -1,
                       1,   1,  1,    0,
                       1,   0,  0,    0,
                       0,   1,  0,    0,
                       0,   0,  1,    0),
                     nrow = 7,
                     byrow = TRUE),
  
  # Signs of constraints
  const.dir = c(">=",
                ">=",
                ">=",
                "=",
                ">=",
                ">=",
                ">="),
  
  # RHSs of constraints
  const.rhs = c(0,
                0,
                0,
                1,
                0,
                0,
                0)
  
)

# Value of the game (adjusted backwards)
lp_object$objval - 5

# Option probabilities
lp_object$solution[1:3]
