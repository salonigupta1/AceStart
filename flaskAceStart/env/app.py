from flask import Flask, render_template, request
import numpy as np
import joblib
#create an instance of Flask
app = Flask(__name__)

@app.route('/')
def home():
    return render_template('home.html')


@app.route('/predict/', methods=['GET','POST'])
def predict():
    
    if request.method == "POST":
        #get form data
        sepal_length = request.form.get('sepal_length')
        sepal_width = request.form.get('sepal_width')
        petal_length = request.form.get('petal_length')
        petal_width = request.form.get('petal_width')
        
        #call preprocessDataAndPredict and pass inputs
        try:
            prediction = preprocessDataAndPredict(sepal_length, sepal_width, petal_length, petal_width)
            #pass prediction to template
            return render_template('predict.html', prediction = prediction)
   
        except ValueError:
            return "Please Enter valid values"
  
        pass
    pass

def preprocessDataAndPredict(sepal_length, sepal_width, petal_length, petal_width):
    
    import pandas as pd
    import re
    import nltk
    nltk.download('stopwords')
    from nltk.corpus import stopwords
    from nltk.stem.porter import PorterStemmer
    ps = PorterStemmer()
    corpus = []
    df=pd.read_csv('spam_check_data.csv')
    print(df.head())
    for i in range(0, len(df)):
        review = re.sub('[^a-zA-Z]', ' ', df['sentence'][i])
        review = review.lower()
        review = review.split()
        
        review = [ps.stem(word) for word in review if not word in stopwords.words('english')]
        review = ' '.join(review)
        corpus.append(review)
    from sklearn.feature_extraction.text import TfidfVectorizer
    cv = TfidfVectorizer(max_features=500) #converting strings into vectors of numbers
    X = cv.fit_transform(corpus).toarray()
    
    y=pd.get_dummies(df['label'])
    y=y.iloc[:,1].values
    
    from sklearn.model_selection import train_test_split
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.10)
        
    #open file
    file = open("model.pkl","rb")
    
    #load trained model
    trained_model = joblib.load(file)
    
    #predict
    prediction = trained_model.predict(X_test)
    
    return prediction
    
    pass

if __name__ == '__main__':
    app.run(debug=True)