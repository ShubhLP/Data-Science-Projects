import streamlit as st
import pandas as pd
import joblib
import os

# load model
model_path = os.path.join(os.path.dirname(__file__), 'churn.model.logreg.pkl')
model = joblib.load(model_path)

st.title('Customer Churn Prediction')

st.write('Enter the details below:')

# Inputs

gender = st.selectbox('Gender', ('Male', 'Female'))
Partner = st.selectbox('Has Partner?', ('Yes', 'No'))
Dependents =  st.selectbox('Dependents?', ('Yes', 'No'))
PhoneService = st.selectbox('Phone Service', ('Yes', 'No'))
MultipleLines = st.selectbox('Multiple Lines', ('Yes', 'No', 'No phone service'))

InternetService = st.selectbox('Internet Service', ('Yes', 'No', 'No internet service'))
disable_dependents = InternetService == "No internet service"
dependent_options = ('Yes', 'No') if not disable_dependents else ('No internet service',)

OnlineSecurity = st.selectbox('Online Security', dependent_options, index=0, disabled=disable_dependents)
OnlineBackup = st.selectbox('Online Backup', dependent_options, index=0, disabled=disable_dependents)
DeviceProtection = st.selectbox('Device Protection', dependent_options, index=0, disabled=disable_dependents)
TechSupport = st.selectbox('Tech Support', dependent_options, index=0, disabled=disable_dependents)
StreamingTV = st.selectbox('Streaming TV', dependent_options, index=0, disabled=disable_dependents)
StreamingMovies = st.selectbox('Streaming Movies', dependent_options, index=0, disabled=disable_dependents)

Contract = st.selectbox("Contract Type", ["Month-to-month", "One year", "Two year"])
PaperlessBilling = st.selectbox("Paperless Billing", ["Yes", "No"])
PaymentMethod = st.selectbox('PaymentMethod', ('Electronic check', 'Mailed check', 'Bank transfer (automatic)', 'Credit card (automatic)'))

senior_input = st.selectbox("Senior Citizen?", ('Yes', 'No'))
SeniorCitizen = 1 if senior_input == 'Yes' else 0

tenure = st.select_slider('Tenure', options = range(0, 73), value = 12)
MonthlyCharges = st.number_input('Monthly Charges $:', min_value=0.0, placeholder = 'Enter monthly charges...', value = None)
TotalCharges = st.number_input("Total Charges $:", min_value=0.0, placeholder = 'Enter monthly charges...', value = None)


if st.button('Predict Churn'):
    input_data = pd.DataFrame([{
        "gender": gender,
        "SeniorCitizen": SeniorCitizen,
        "Partner": Partner,
        "Dependents": Dependents,
        "tenure": tenure,
        "PhoneService": PhoneService,
        "MultipleLines": MultipleLines,
        "InternetService": InternetService,
        "OnlineSecurity": OnlineSecurity,
        "OnlineBackup": OnlineBackup,
        "DeviceProtection": DeviceProtection,
        "TechSupport": TechSupport,
        "StreamingTV": StreamingTV,
        "StreamingMovies": StreamingMovies,
        "Contract": Contract,
        "PaperlessBilling": PaperlessBilling,
        "PaymentMethod": PaymentMethod,
        "MonthlyCharges": MonthlyCharges,
        "TotalCharges": TotalCharges
    }])

    probability = model.predict_proba(input_data)[:, 1][0]
    prediction = int(probability >= 0.35)

    st.write(f'Prediction Probabilty: {probability:.2f}')

    if prediction == 1:
        st.error('High Risk of Churning', icon="🚨")
    else:
        st.success('Low Risk of Churning!', icon="✅")
