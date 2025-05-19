# Inventory Days vs Profitability Analysis

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

# Load cleaned dataset
df = pd.read_csv('Cleaned_Retail_Transactions.csv')

# Simulate InventoryDays
np.random.seed(42)
df['InventoryDays'] = np.random.randint(10, 100, size=len(df))

# Correlation analysis
correlation = df['InventoryDays'].corr(df['Profit'])
print(f'Correlation between Inventory Days and Profit: {correlation:.2f}')

# Scatter plot
plt.figure(figsize=(10,6))
sns.scatterplot(data=df, x='InventoryDays', y='Profit', hue='ProductCategory', alpha=0.7)
plt.title('Inventory Days vs Profit by Product Category')
plt.xlabel('Inventory Days')
plt.ylabel('Profit')
plt.legend(title='Product Category', bbox_to_anchor=(1.05, 1), loc='upper left')
plt.tight_layout()
plt.show()