# Credit Risk Default Prediction

## 📌 Overview
Credit Risk Default Prediction is an end-to-end machine learning project focused on predicting loan default risk in highly imbalanced financial datasets.

The project was built with a strong emphasis on real-world credit risk management, not leaderboard-style metrics. Instead of optimizing for Accuracy or ROC-AUC alone, the system prioritizes:

Detecting as many risky borrowers as possible (high Recall)
Reducing costly False Negatives
Optimizing decision thresholds based on business objectives
Maintaining model interpretability through Explainable AI (XAI)
The final solution uses XGBoost, Optuna, and SHAP to create a robust, explainable, and production-oriented credit risk pipeline.

## 🛠️ Tech Stack

Language: Python
Machine Learning: XGBoost
Hyperparameter Optimization: Optuna
Explainable AI: SHAP
Data Processing: Pandas, NumPy
Visualization: Matplotlib, Seaborn
Utilities: Scikit-Learn

## 📂 Project Structure

- ├── Data.ipynb        # Data cleaning & preprocessing
- ├── Feature.ipynb     # Feature engineering & feature analysis
- ├── Train.ipynb       # Model training, tuning, evaluation
- ├── README.md

## ⚙️ Project Pipeline

The project pipeline is divided into two main phases, corresponding to the repository structure: 
### Phase 1: Data Preprocessing & EDA (Data.ipynb) 
1. **Business-Logic Data Cleaning:** Detected and removed absurd data points (e.g., applicant age > 100, or employment length exceeding actual working-age years).
2. **Advanced Imputation:** Avoided naive mean imputation. Missing loan interest rates were filled using the median of their respective loan_grade; employment lengths were imputed contextually based on employment status or age-group medians.
3. **Feature Encoding:** Applied *Label Encoding* for ordinal categorical variables (like loan_grade A-G) and *One-Hot Encoding* for nominal variables (intent, home_ownership).
4. **Feature Engineering:** Synthesized new indicators such as total_debt to capture the financial leverage and debt burden of applicants.

### Phase 2: Feature Engineering (Feature.ipynb) 
Initialize 4 new characteristics: free_cash_flow, net_income_after_total_debt, risk_emp_debt, and adjusted_loan_to_income.

### Phase 3: Model Training & Risk Mitigation (Train.ipynb) 
1. **Strict Data Splitting:** Implemented a rigorous **70% Train / 15% Validation / 15% Test** split. Used the stratify parameter to preserve the highly imbalanced class distribution across all sets. The Test set was strictly locked away until final evaluation.
2. **Class Imbalance Handling:** Calculated the natural scale_pos_weight (majority/minority ratio) to penalize the XGBoost loss function, forcing the model to focus on the minority default class.
3. **Bayesian Hyperparameter Tuning:** Utilized Optuna to autonomously search for the optimal model complexity constraints (learning_rate, max_depth, colsample_bytree, subsample, min_child_weight).
4. **Overfitting Prevention:** Integrated early_stopping_rounds=30 evaluated on the Validation set.
5. **Threshold Optimization:** Scanned a fine-grained threshold space (0.01 steps) to maximize the **F2-Score** (which weights Recall twice as much as Precision), overriding the naive 0.5 default threshold.
6. **Explainable AI (XAI):** Deployed SHAP's TreeExplainer to generate Global Summary Plots (identifying top risk drivers) and Local Waterfall Plots (providing transparent, individual explanations for loan rejections).

## 📊 Model Performance
- The project focuses primarily on:
PR-AUC
Recall
F2-Score
- Ranking Performance
Metric	Score
PR-AUC	0.8937
ROC-AUC	0.94
- Business-Oriented Performance
(Optimal Threshold = 0.21)

- Metric	Score
- Recall	0.8274
- Precision	0.71
- F2-Score	0.7998

## 📉 Confusion Matrix
### Final Confusion Matrix
```text
                  Predicted: Good (0)   Predicted: Default (1)
Actual: Good (0)         3453                  368         (False Positives - Opportunity Cost)
Actual: Default (1)       184                  882         (True Positives - Capital Saved)
