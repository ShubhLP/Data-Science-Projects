# Set working directory and load libraries
setwd("/Users/shubham/Documents/Rutgers University/MS in Data Science/Spring 2024/Statistical Modelling and Computing/Project")

library(flexsurv)
library(survival)
library(readxl)
library(ggplot2)
library(reshape2)

# Data loading
breast_cancer_data <- read_excel("gbcs.xls")
View(breast_cancer_data)

# Data preparation
attach(breast_cancer_data)
tumor_grade <- as.factor(grade)
received_hormone <- as.factor(hormone)
age_group <- factor(with(breast_cancer_data, ifelse(age <= 30, 1, ifelse(age <= 50, 2, 3))))
age_group <- as.factor(age_group)
survival_time <- survtime
event_status <- censdead
X <- cbind(age_group, menopause, received_hormone, size, tumor_grade, nodes, prog_recp, estrg_recp)


# Summary statistics
group <- age_group
summary(survival_time)
summary(event_status)
summary(group)
summary(X)

# Kaplan-Meier non-parametric analysis
km_surv <- survfit(Surv(survival_time, event_status) ~ 1)
summary(km_surv)
plot(km_surv, xlab = "Time", ylab = "Survival Probability", main = "Kaplan-Meier Survival Curve")

# Kaplan-Meier non-parametric analysis by group
km_surv1 <- survfit(Surv(survival_time, event_status) ~ group)
summary(km_surv1)
plot(km_surv1, xlab = "Time", ylab = "Survival Probability", col = c("red", "blue"), main = "Kaplan-Meier Survival Curve by Age Group")
legend('topright', "hormone-Yes", lty = 1, col = c('red'), bty = 'n', cex = .75)

# Cox-Proportional hazard model
cox_prop_haz_model <- coxph(Surv(survival_time, event_status) ~ age + menopause + hormone + size + nodes + prog_recp + estrg_recp + grade - 1, method = "breslow")
summary(cox_prop_haz_model)
plot(survfit(cox_prop_haz_model), main = "Survival Curve from Cox-Proportional Hazard Model", xlab = "Time", ylab = "Survival Probability")

# final model
cox_prop_haz_model2 <- coxph(Surv(survival_time, event_status) ~ age + size + grade + prog_recp + nodes, method = "breslow")
summary(cox_prop_haz_model2)
plot(survfit(cox_prop_haz_model2), main = "Survival Curve from Cox-Proportional Hazard Model", xlab = "Time", ylab = "Survival Probability")

time.bc <- coxph(Surv(survival_time, event_status) ~ age + size + nodes + prog_recp + estrg_recp, method = "breslow")
time.bc.zph <- cox.zph(time.bc, transform = 'log')
summary(time.bc)
plot(survfit(time.bc), col = c("red", "blue", "green"), lty = 1:3,
     main = "Survival Curves by Group",
     xlab = "Time",
     ylab = "Survival Probability")

# Add legend
legend("topright",
       legend = c("Age <= 30", "30 < Age <= 50", "Age > 50"),
       col = c("red", "blue", "green"),
       lty = 1:3,
       bty = "n",
       cex = 0.8)

plot(time.bc.zph)
plot(time.bc.zph[1], main = "Schoenfeld Residuals for Age", xlab = "Time", ylab = "Schoenfeld Residuals")
plot(time.bc.zph[2], main = "Schoenfeld Residuals for Size", xlab = "Time", ylab = "Schoenfeld Residuals")
plot(time.bc.zph[3], main = "Schoenfeld Residuals for Nodes", xlab = "Time", ylab = "Schoenfeld Residuals")
plot(time.bc.zph[4], main = "Schoenfeld Residuals for Prog Recp", xlab = "Time", ylab = "Schoenfeld Residuals")
plot(time.bc.zph[5], main = "Schoenfeld Residuals for Estrg Recp", xlab = "Time", ylab = "Schoenfeld Residuals")

# Exponential model
surv_exp <- flexsurvreg(Surv(survival_time, event_status) ~ as.factor(grade), dist = 'exponential', data = breast_cancer_data)
plot(surv_exp, main = "Survival Curve from Exponential Model", xlab = "Time", ylab = "Survival Probability")

# Weibull model
surv_wei <- flexsurvreg(Surv(survival_time, event_status) ~ as.factor(grade), dist = 'weibull', data = breast_cancer_data)
plot(surv_wei, main = "Survival Curve from Weibull Model", xlab = "Time", ylab = "Survival Probability")

# Log-logistic model
surv_log <- flexsurvreg(Surv(survival_time, event_status) ~ as.factor(grade), dist = 'lnorm', data = breast_cancer_data)
plot(surv_log, main = "Survival Curve from Log-Normal Model", xlab = "Time", ylab = "Survival Probability")

# Compute the correlation matrix
cor_matrix <- cor(breast_cancer_data[, c("age", "menopause", "hormone", "size", "grade", "nodes", "prog_recp", "estrg_recp", "rectime", "censrec")])

# Convert the correlation matrix to a long format
cor_melted <- melt(cor_matrix)

# Create the heatmap
# Assuming cor_melted is your melted correlation matrix
ggplot(data = cor_melted, aes(x = Var1, y = Var2)) +
  geom_tile(aes(fill = value), color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab",
                       name="Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1)) +
  coord_fixed() +
  labs(title = "Correlation Plot of Variables",
       x = "Variables",
       y = "Variables") +
  # Add annotations
  geom_text(aes(label = sprintf("%.2f", value)), 
            color = "black", 
            size = 2) +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank())


# Kaplan-Meier survival curve by hormone therapy
km_surv_hormone <- survfit(Surv(survival_time, event_status) ~ hormone)
summary(km_surv_hormone)

plot(km_surv_hormone, 
     xlab = "Time", 
     ylab = "Survival Probability", 
     col = c("red", "blue"), 
     main = "Kaplan-Meier Survival Curve by Hormone Therapy")

legend('topright', 
       legend = c("Hormone - No", "Hormone - Yes"), 
       lty = 1, 
       col = c('red', 'blue'), 
       bty = 'n', 
       cex = 0.75)

# Cox-Proportional Hazard model using hormone therapy as a categorical variable
cox_prop_haz_hormone <- coxph(Surv(survival_time, event_status) ~ hormone, data = breast_cancer_data)
summary(cox_prop_haz_hormone)

# Cox-Proportional Hazard model using grade as a categorical variable
cox_prop_haz_grade <- coxph(Surv(survival_time, event_status) ~ grade, data = breast_cancer_data)
summary(cox_prop_haz_grade)

# Cox-Proportional Hazard model using menopause as a categorical variable
cox_prop_haz_menopause <- coxph(Surv(survival_time, event_status) ~ menopause, data = breast_cancer_data)
summary(cox_prop_haz_menopause)

# Parametric Survival models
# Exponential model
surv_exp <- flexsurvreg(Surv(survival_time, event_status) ~ 1, dist = 'exponential', data = breast_cancer_data)
summary(surv_exp)
plot(surv_exp, main = "Exponential Survival Model", xlab = "Time", ylab = "Survival Probability")

# Weibull model
surv_wei <- flexsurvreg(Surv(survival_time, event_status) ~ 1, dist = 'weibull', data = breast_cancer_data)
summary(surv_wei)
plot(surv_wei, main = "Weibull Survival Model", xlab = "Time", ylab = "Survival Probability")

# Log-normal model
surv_log <- flexsurvreg(Surv(survival_time, event_status) ~ 1, dist = 'lnorm', data = breast_cancer_data)
summary(surv_log)
plot(surv_log, main = "Log-Normal Survival Model", xlab = "Time", ylab = "Survival Probability")

# Plot combined survival curves
plot(surv_exp, col = "red", lty = 1, lwd = 2, 
     main = "Parametric Survival Models Comparison", 
     xlab = "Time", ylab = "Survival Probability")
lines(surv_wei, col = "blue", lty = 2, lwd = 2)
lines(surv_log, col = "green", lty = 3, lwd = 2)

# Add legend
legend("topright", 
       legend = c("Exponential", "Weibull", "Log-Normal"), 
       col = c("red", "blue", "green"), 
       lty = c(1, 2, 3), 
       lwd = 2, 
       bty = "n", 
       cex = 0.8)

# Create Kaplan-Meier curves by Tumor Grade
km_surv_grade <- survfit(Surv(survival_time, event_status) ~ grade, data = breast_cancer_data)

# Plot Kaplan-Meier curves
plot(km_surv_grade, 
     col = c("red", "blue", "green"), 
     lty = 1:3,
     main = "Kaplan-Meier Survival Curve by Tumor Grade",
     xlab = "Time",
     ylab = "Survival Probability")

# Define labels for the legend
grade_labels <- c("Grade 1", "Grade 2", "Grade 3")

# Add legend with meaningful labels
legend("topright",
       legend = grade_labels,
       col = c("red", "blue", "green"),
       lty = 1:3,
       bty = "n",
       cex = 0.8)

# Check proportional hazards assumption using cox.zph function
cox_prop_haz_grade <- coxph(Surv(survival_time, event_status) ~ grade, data = breast_cancer_data)
cox_prop_haz_grade_zph <- cox.zph(coxph_grade)

# Print test results
print(cox_prop_haz_grade_zph)

# Create Kaplan-Meier curves by Menopause
km_surv_menopause <- survfit(Surv(survival_time, event_status) ~ menopause, data = breast_cancer_data)

# Plot Kaplan-Meier curves
plot(km_surv_menopause, 
     col = c("blue", "red"), 
     lty = 1:2,
     main = "Kaplan-Meier Survival Curve by Menopause Status",
     xlab = "Time",
     ylab = "Survival Probability")

# Define labels for the legend
menopause_labels <- c("No Menopause", "Menopause")

# Add legend with meaningful labels
legend("topright",
       legend = menopause_labels,
       col = c("blue", "red"),
       lty = 1:2,
       bty = "n",
       cex = 0.8)

ggplot(breast_cancer_data, aes(x = age)) +
  geom_density(fill = "skyblue", color = "blue") +
  labs(title = "Density Plot of Age", x = "Age", y = "Density")

ggplot(breast_cancer_data, aes(x = nodes)) +
  geom_density(fill = "white", color = "green") +
  labs(title = "Density Plot of Lymph Nodes", x = "Nodes", y = "Density")

ggplot(breast_cancer_data, aes(x = "", y = prog_recp)) +
  geom_boxplot(fill = "skyblue", color = "blue") +
  labs(title = "Box Plot of Progesterone", x = "", y = "Progesterone")
