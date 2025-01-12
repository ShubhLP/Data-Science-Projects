Project Overview

This project involves a comprehensive analysis of breast cancer survival data using statistical modeling techniques. The goal is to uncover key factors influencing patient survival rates and to build robust models that can predict survival outcomes. The analysis utilizes various statistical models, including Kaplan-Meier non-parametric analysis, Cox-proportional hazard models, and parametric survival models such as exponential and Weibull models.

Objectives

To explore and clean breast cancer survival data.
To identify key predictors of survival using statistical models.
To apply and compare different survival models for predictive performance.
To provide actionable insights for healthcare professionals and researchers.
Dataset

The dataset used for this analysis contains information about breast cancer patients, including clinical and demographic variables. The key variables include:

Patient ID
Age
Tumor Stage
Lymph Node Involvement
Treatment Type
Follow-up Time
Survival Status
Methodology

The analysis was conducted in the following steps:

Data Preprocessing
Handled missing values and outliers.
Encoded categorical variables for modeling.
Scaled numerical variables to improve model performance.
Exploratory Data Analysis (EDA)
Performed univariate and bivariate analysis to understand the distribution of key variables.
Visualized survival curves using the Kaplan-Meier estimator.
Modeling
Kaplan-Meier Non-Parametric Analysis: Used to estimate survival functions and visualize survival probabilities over time.
Cox Proportional Hazards Model: Applied to identify significant predictors of survival while accounting for covariates.
Parametric Survival Models: Fitted exponential and Weibull models to assess survival under specific parametric assumptions.
Model Evaluation
Compared model performance using metrics such as log-likelihood, AIC, and graphical residual analysis.
Results

Kaplan-Meier analysis provided insights into survival probabilities at different time intervals.
The Cox model revealed that tumor stage and lymph node involvement were significant predictors of survival.
The Weibull model showed the best fit among parametric models, with a lower AIC compared to the exponential model.
