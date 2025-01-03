import streamlit as st
import numpy as np
import joblib
import os

base_dir = os.path.dirname(os.path.abspath(__file__))
model_path = os.path.join(base_dir, 'logistic_model.pkl')

model = joblib.load(model_path)

risks = {0: 'Low', 1: 'Medium', 2: 'High'}

st.title("Customer Credit and Loan Risk Prediction App")
st.write("Classify customers into risk categories based on their profile.")

credit_per_month_risk = st.slider("Credit Per Month Risk (0: Low, 1: Medium, 2: High)", 0, 2, 1)
credit_util_score = st.slider("Credit Utilization Score (0: Low, 1: High)", 0.0, 1.0, 0.5, step=0.1)
housing_risk = st.slider("Housing Risk (0: Low, 1: High)", 0, 1, 1)
savings_risk = st.slider("Savings Risk (0: Low, 1: High)", 0, 1, 1)

if st.button("Predict Risk"):
    input_features = np.array([[credit_per_month_risk, credit_util_score, housing_risk, savings_risk]])
    
    predicted_risk = model.predict(input_features)
    predicted_risk_mapped = risks[predicted_risk[0]]
    
    st.success(f"Predicted Risk Category: {predicted_risk[0]} - {predicted_risk_mapped}")
