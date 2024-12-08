# Fake News Detection using Logistic Regression and TF-IDF

This project focuses on building a machine learning model for fake news detection using a Logistic Regression classifier and TF-IDF (Term Frequency-Inverse Document Frequency) for text vectorization. The model is trained on a dataset of news articles and predicts whether a given news article is real or fake.

Features

Text Preprocessing: The text data is preprocessed by converting text to lowercase, removing punctuation, tokenizing, and lemmatizing the words.
TF-IDF Vectorization: The text data is vectorized using TF-IDF to convert the text into numerical features that can be fed into a machine learning model.
Logistic Regression Model: A Logistic Regression model is trained to classify news articles as real or fake.
Streamlit Web Application: A simple web interface built with Streamlit where users can input news articles and get predictions about whether they are real or fake.
Table of Contents

- Installation
- Usage
- Project Structure
- Technologies
- License
- Installation

To run the project locally, follow the steps below:

Clone the repository:
git clone https://github.com/your-username/fake-news-detection.git
cd fake-news-detection
Set up a virtual environment (recommended):
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
Install required dependencies:
pip install -r requirements.txt
Run the Streamlit application:
streamlit run app.py
Open your browser and go to http://localhost:8501 to interact with the web application.
Usage

Training: The model is trained on the provided news dataset. You can preprocess the data, train the model, and save the vectorizer and model using the joblib library.
After training, the model and vectorizer are serialized and saved into two separate .pkl files (logistic_model.pkl and tfidf_vectorizer.pkl). These files can be loaded into the Streamlit app for real-time prediction.
Prediction: In the Streamlit app, users can input a news article, and the model will predict whether the article is real or fake based on the trained logistic regression model.
