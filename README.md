Credit Risk Default Prediction

📌 Overview
Credit Risk Default Prediction is an end-to-end machine learning project focused on predicting loan default risk in highly imbalanced financial datasets.
The project was built with a strong emphasis on real-world credit risk management, not leaderboard-style metrics. Instead of optimizing for Accuracy or ROC-AUC alone, the system prioritizes:
Detecting as many risky borrowers as possible (high Recall)
Reducing costly False Negatives
Optimizing decision thresholds based on business objectives
Maintaining model interpretability through Explainable AI (XAI)
The final solution uses XGBoost, Optuna, and SHAP to create a robust, explainable, and production-oriented credit risk pipeline.

🛠️ Tech Stack

Language: Python

Machine Learning: XGBoost
Hyperparameter Optimization: Optuna
Explainable AI: SHAP
Data Processing: Pandas, NumPy
Visualization: Matplotlib, Seaborn
Utilities: Scikit-Learn

📂 Project Structure

├── Data.ipynb        # Data cleaning & preprocessing
├── Feature.ipynb     # Feature engineering & feature analysis
├── Train.ipynb       # Model training, tuning, evaluation
├── README.md

⚙️ Project Pipeline

1️⃣ Data Cleaning & Preprocessing (Data.ipynb)
Data Validation
Removed unrealistic and inconsistent records such as:
Invalid ages
Employment length exceeding possible working years
Incorrect financial values
Missing Value Handling
Applied contextual imputation instead of naive global averages:
loan_int_rate imputed using median interest rate within each loan_grade
person_emp_length imputed based on employment-related patterns
Encoding
Used different encoding strategies depending on feature type:
Label Encoding for ordinal variables
One-Hot Encoding for nominal categorical variables

2️⃣ Feature Engineering (Feature.ipynb)
Created additional financial indicators to improve risk representation.
Examples include:
Debt-related ratios
Financial burden indicators
Aggregated risk features
The goal was to better capture borrower behavior and repayment capacity beyond raw variables.

3️⃣ Model Training (Train.ipynb)
Data Splitting
Used a strict:
70% Training
15% Validation
15% Test
split with stratify to preserve class distribution.
The test set remained completely isolated until final evaluation.
Handling Class Imbalance
Because default cases are heavily underrepresented, the project used:
scale_pos_weight
to increase the learning importance of minority-class samples.
This helps the model focus more on identifying risky borrowers.
Hyperparameter Optimization
Used Optuna for Bayesian hyperparameter optimization.
Main tuned parameters included:
learning_rate
max_depth
min_child_weight
subsample
colsample_bytree
Overfitting Prevention
Applied:
early_stopping_rounds
using the validation set to stop training when performance stopped improving.
Threshold Optimization
Instead of using the default threshold of 0.5, the project searched for the optimal classification threshold to maximize the F2-Score.
Why F2-score?
Because in credit risk prediction:
Missing a defaulter (False Negative) is far more expensive than rejecting a good customer.
F2-score emphasizes Recall more heavily than Precision.

📊 Model Performance
Evaluation Metrics
The project focuses primarily on:
PR-AUC
Recall
F2-Score

Final Test Performance
Ranking Performance
Metric	Score
PR-AUC	0.8937
ROC-AUC	0.94

Business-Oriented Performance

(Optimal Threshold = 0.21)

Metric	Score
Recall	0.8274
Precision	0.71
F2-Score	0.7998

📉 Confusion Matrix
                  Predicted Good    Predicted Default

Actual Good            3453                 368
Actual Default          184                 882
