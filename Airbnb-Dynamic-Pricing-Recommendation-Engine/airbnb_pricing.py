# Final Airbnb Dynamic Pricing Recommendation Engine (No 'availability_365')

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
import joblib

# Load dataset
print("Loading data...")
df = pd.read_csv("airbnb_dashboard_data.csv", low_memory=False)
df = df[df['price'] > 0]  # Clean non-positive prices

# Sampling for performance
df = df.sample(n=20000, random_state=42)  # Use a sample to speed up

# Fill missing
df['neighbourhood_group'] = df['neighbourhood_group'].fillna('Unknown')

# Selected features (excluding availability_365)
features = ['room_type', 'neighbourhood_group', 'neighbourhood',
            'minimum_nights', 'number_of_reviews']
target = 'price'

X = df[features]
y = df[target]

# Preprocessing
categorical_features = ['room_type', 'neighbourhood_group', 'neighbourhood']
numerical_features = ['minimum_nights', 'number_of_reviews']

categorical_transformer = OneHotEncoder(drop='first', handle_unknown='ignore')
numerical_transformer = SimpleImputer(strategy='median')

preprocessor = ColumnTransformer([
    ('cat', categorical_transformer, categorical_features),
    ('num', numerical_transformer, numerical_features)
])

model = Pipeline([
    ('preprocessor', preprocessor),
    ('regressor', RandomForestRegressor(n_estimators=50, max_depth=10, random_state=42))
])

# Train/test split and training
print("Training model...")
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
model.fit(X_train, y_train)

# Evaluation
y_pred = model.predict(X_test)
rmse = np.sqrt(mean_squared_error(y_test, y_pred))
print(f"Model RMSE: ${rmse:.2f}")

# Sample prediction
sample_input = pd.DataFrame([{
    'room_type': 'Entire home/apt',
    'neighbourhood_group': 'Unknown',
    'neighbourhood': 'Mission',
    'minimum_nights': 3,
    'number_of_reviews': 45
}])
predicted_price = model.predict(sample_input)[0]
print(f"Suggested Price: ${predicted_price:.2f}")

# Export clean version
export_df = df[['neighbourhood_group', 'neighbourhood', 'room_type', 'price',
                'minimum_nights', 'number_of_reviews', 'latitude', 'longitude']]
export_df.to_csv("clean_airbnb_data.csv", index=False)

# --- Visualizations ---

# Room Type Distribution Pie
plt.figure(figsize=(6, 6))
df['room_type'].value_counts().plot.pie(autopct='%1.1f%%', startangle=140)
plt.title("Room Type Distribution")
plt.ylabel("")
plt.savefig("room_type_distribution.png")
plt.close()

# Avg Price by Neighbourhood (Top 20)
top_neigh = df.groupby('neighbourhood')['price'].mean().sort_values(ascending=False).head(20)
plt.figure(figsize=(10, 6))
top_neigh.plot(kind='bar', color='skyblue')
plt.title("Top 20 Neighbourhoods by Avg Price")
plt.xlabel("Neighbourhood")
plt.ylabel("Average Price ($)")
plt.xticks(rotation=75)
plt.tight_layout()
plt.savefig("avg_price_by_neighbourhood.png")
plt.close()

# Scatter Plot: Reviews vs Price (under $500)
plot_df = df[df['price'] < 500]
plt.figure(figsize=(8, 6))
sns.scatterplot(x='number_of_reviews', y='price', data=plot_df, alpha=0.4)
plt.title("Reviews vs Price (Price < $500)")
plt.xlabel("Number of Reviews")
plt.ylabel("Price ($)")
plt.tight_layout()
plt.savefig("reviews_vs_price.png")
plt.close()

# Feature Importance Plot
rf_model = model.named_steps['regressor']
encoder = model.named_steps['preprocessor'].named_transformers_['cat']
encoded_features = encoder.get_feature_names_out(categorical_features)
feature_names = np.concatenate([encoded_features, numerical_features])

importances = rf_model.feature_importances_
feat_imp_df = pd.Series(importances, index=feature_names).sort_values(ascending=False).head(15)

plt.figure(figsize=(10, 6))
feat_imp_df.plot(kind='barh', color='green')
plt.title("Top 15 Feature Importances")
plt.xlabel("Importance")
plt.gca().invert_yaxis()
plt.tight_layout()
plt.savefig("feature_importance.png")
plt.close()
