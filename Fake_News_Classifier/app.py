import streamlit as st
import json
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
import joblib
import numpy as np
import os

base_dir = os.path.dirname(os.path.abspath(__file__))

vectorizer_file = os.path.join(base_dir, 'tfidf_vectorizer.json')
model_file = os.path.join(base_dir, 'logistic_model.pkl')

if not os.path.exists(vectorizer_file):
    st.error(f"File not found: {vectorizer_file}")
elif not os.path.exists(model_file):
    st.error(f"File not found: {model_file}")
else:
    with open(vectorizer_file, 'r') as f:
        vectorizer_params = json.load(f)

    vectorizer = TfidfVectorizer(
        vocabulary=vectorizer_params['vocabulary'],
        stop_words=vectorizer_params['stop_words'],
        max_features=vectorizer_params['max_features']
    )

    vectorizer.idf_ = np.array(vectorizer_params['idf_'])

    model = joblib.load(model_file)

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
