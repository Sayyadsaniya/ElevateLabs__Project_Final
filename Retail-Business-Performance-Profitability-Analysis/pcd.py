import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv("Cleaned_Retail_Transactions.csv")

plt.figure(figsize=(10, 6))
category_counts = df['ProductCategory'].value_counts().sort_values(ascending=False)
sns.barplot(x=category_counts.values, y=category_counts.index, palette='viridis')
plt.title('Product Category Distribution')
plt.xlabel('Number of Transactions')
plt.ylabel('Product Category')
plt.tight_layout()
plt.show()