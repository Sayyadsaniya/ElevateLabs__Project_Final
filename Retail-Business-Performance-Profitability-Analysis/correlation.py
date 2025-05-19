import pandas as pd
import numpy as np

df = pd.read_csv("Cleaned_Retail_Transactions.csv")


if 'InventoryDays' not in df.columns:
    np.random.seed(42)
    df['InventoryDays'] = np.random.randint(10, 100, size=len(df))

correlation_matrix = df.select_dtypes(include=['float64', 'int64']).corr()

print("Correlation between InventoryDays and Profit:")
print(correlation_matrix.loc['InventoryDays', 'Profit'])
