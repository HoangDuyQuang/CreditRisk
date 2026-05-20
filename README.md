# Credit Risk Default Prediction System

## 📌 Project Overview

**Credit Risk Default Prediction** is a robust machine learning system designed to assess applicant profiles and predict loan defaults. This project tackles core challenges in the banking and fintech sectors, specifically focusing on: **Severe Class Imbalance**, **Financial Cost-Benefit Optimization via Threshold Tuning**, and **Model Interpretability (Explainable AI)**.

Instead of relying on misleading academic metrics like Accuracy or ROC-AUC (which often paint a falsely optimistic picture on imbalanced datasets), this system is heavily driven by real-world risk management principles. It optimizes business-oriented metrics such as **PR-AUC (Precision-Recall AUC)** and **F2-Score** to drastically minimize False Negatives (the risk of losing principal capital to defaulters).

---

## 🛠️ Technologies & Tools

- **Core Language:** Python
- **Machine Learning Models:** XGBoost, Random Forest, Logistic Regression
- **Hyperparameter Optimization:** Optuna (Bayesian Optimization)
- **Explainable AI (XAI):** SHAP (Shapley Additive exPlanations)
- **Data Processing & Visualization:** Pandas, NumPy, Scikit-Learn, Matplotlib, Seaborn

---

## 🏗️ Pipeline Architecture

The project pipeline is divided into two main phases, corresponding to the repository structure:

### Phase 1: Data Preprocessing & EDA (`Data.ipynb`)
1. **Business-Logic Data Cleaning:** Detected and removed absurd data points (e.g., applicant age > 100, or employment length exceeding actual working-age years).
2. **Advanced Imputation:** Avoided naive mean imputation. Missing loan interest rates were filled using the median of their respective `loan_grade`; employment lengths were imputed contextually based on employment status or age-group medians.
3. **Feature Encoding:** Applied *Label Encoding* for ordinal categorical variables (like `loan_grade` A-G) and *One-Hot Encoding* for nominal variables (`intent`, `home_ownership`).
4. **Feature Engineering:** Synthesized new indicators such as `total_debt` to capture the financial leverage and debt burden of applicants.

### Phase 2: Model Training & Risk Mitigation (`Train.ipynb`)
1. **Strict Data Splitting:** Implemented a rigorous **70% Train / 15% Validation / 15% Test** split. Used the `stratify` parameter to preserve the highly imbalanced class distribution across all sets. The Test set was strictly locked away until final evaluation.
2. **Class Imbalance Handling:** Calculated the natural `scale_pos_weight` (majority/minority ratio) to penalize the XGBoost loss function, forcing the model to focus on the minority default class.
3. **Bayesian Hyperparameter Tuning:** Utilized Optuna to autonomously search for the optimal model complexity constraints (`learning_rate`, `max_depth`, `colsample_bytree`, `subsample`, `min_child_weight`).
4. **Overfitting Prevention:** Integrated `early_stopping_rounds=30` evaluated on the Validation set.
5. **Threshold Optimization:** Scanned a fine-grained threshold space (0.01 steps) to maximize the **F2-Score** (which weights Recall twice as much as Precision), overriding the naive 0.5 default threshold.
6. **Explainable AI (XAI):** Deployed SHAP's `TreeExplainer` to generate Global Summary Plots (identifying top risk drivers) and Local Waterfall Plots (providing transparent, individual explanations for loan rejections).

---

## 📈 Performance (On Independent Test Set)

The final XGBoost model, tuned via Optuna and evaluated using the mathematically derived optimal threshold of **0.25**, delivered exceptional results on unseen data:

### Global Ranking Metrics
- **PR-AUC:** `0.8950` *(The true North Star metric for this project. It strictly evaluates the model's ability to rank actual defaulters without being blinded by the safe majority).*
- **Validation-Test Gap:** `< 0.005` *(Proving absolute stability and absence of overfitting).*

### Business-Driven Performance (At Optimal Threshold = 0.25)
- **F2-Score:** `0.8056`
- **Recall (Default Capture Rate):** `0.8508` $\rightarrow$ Successfully intercepted **85.08%** of actual defaults (907 out of 1066 bad loans).
- **Precision:** `0.6626` $\rightarrow$ For every 3 loans rejected by the AI, 2 were guaranteed actual defaults, keeping the opportunity cost well within profitable margins.

### Final Confusion Matrix
```text
                  Predicted: Good (0)   Predicted: Default (1)
Actual: Good (0)         3363                  458         (False Positives - Opportunity Cost)
Actual: Default (1)       159                  907         (True Positives - Capital Saved)
