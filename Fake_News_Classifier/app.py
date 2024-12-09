import streamlit as st
import json
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
import joblib
import numpy as np

with open('./tfidf_vectorizer.json', 'r') as f:
    vectorizer_params = json.load(f)

# Recreate the TfidfVectorizer using the loaded parameters
vectorizer = TfidfVectorizer(
    vocabulary=vectorizer_params['vocabulary'],
    stop_words=vectorizer_params['stop_words'],
    max_features=vectorizer_params['max_features']
)

# Manually set the idf_ attribute
vectorizer.idf_ = np.array(vectorizer_params['idf_'])

model = joblib.load('logistic_model.pkl')

st.title("News Article Classifier")
user_input = st.text_area("Enter News Article:")

if st.button("Check News"):
    if user_input.strip():
        try:
            processed_input = vectorizer.transform([user_input])
            st.write(f"Processed input shape: {processed_input.shape}")
            prediction = model.predict(processed_input)

            if prediction[0] == 1:
                st.success("This news is likely REAL.")
            else:
                st.error("This news is likely FAKE.")
        except Exception as e:
            st.error(f"Error: {str(e)}")
    else:
        st.warning("Please enter a news article!")
