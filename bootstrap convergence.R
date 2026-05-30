set.seed(42)

# Simulate Poisson-distributed data
n <- 1000
x <- rnorm(n)
lambda <- exp(1 + 0.5 * x)  # True Poisson mean function
y <- rpois(n, lambda)

data <- data.frame(y, x)

# Fit Poisson GLM (correct model)
poisson_model <- glm(y ~ x, data = data, family = poisson(link = "log"))

# Transform response to approximate log-linear behavior
data$log_y <- log(data$y + 1)

# Fit OLS on log-transformed response
ols_log_model <- lm(log_y ~ x, data = data)

# Store Poisson GLM estimates
true_coefs <- coef(poisson_model)
true_se <- summary(poisson_model)$coefficients[, 2]

# Bootstrap process
B <- 1000
boot_coefs <- matrix(NA, nrow = B, ncol = length(true_coefs))

for (i in 1:B) {
  boot_data <- data[sample(1:n, replace = TRUE), ]
  boot_model <- lm(log_y ~ x, data = boot_data)
  boot_coefs[i, ] <- coef(boot_model)
}

# Compute bootstrap means and SEs
boot_mean <- colMeans(boot_coefs)
boot_se <- apply(boot_coefs, 2, sd)

# Exponentiate coefficients to get back to Poisson scale
boot_mean <- exp(boot_mean)
true_coefs <- exp(true_coefs)

# Check convergence
convergence <- all(abs(boot_mean - true_coefs) < 0.01) &&
  all(abs(boot_se - true_se) < 0.01)

# Print results
cat("Poisson GLM Coefficients:\n")
print(true_coefs)
cat("\nBootstrapped Log-OLS Coefficients (Exp Transformed):\n")
print(boot_mean)
cat("\nPoisson GLM SE:\n")
print(true_se)
cat("\nBootstrapped Log-OLS SE:\n")
print(boot_se)
cat("\nDid transformed OLS bootstraps converge to Poisson GLM estimates? ", convergence, "\n")
