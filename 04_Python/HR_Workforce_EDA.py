import matplotlib.pyplot as plt
# Import pandas for data analysis
import pandas as pd

# Load the cleaned HR dataset
df = pd.read_csv("HR_Workforce_Cleaned.csv")

# Clean column names by removing hidden spaces or characters
df.columns = df.columns.str.replace('\ufeff', '', regex=False).str.strip()

# Standardize text values in the Overtime column
df["Overtime"] = df["Overtime"].str.strip().str.title()

# Display the first 5 rows
print(df.head())

# Check the number of rows and columns
print("\nDataset Shape:")
print(df.shape)

# Display column names and data types
print("\nDataset Information:")
df.info()

# Check missing values in each column
print("\nMissing Values:")
print(df.isnull().sum())

# Display summary statistics for numerical columns
print("\nSummary Statistics:")
print(df.describe())

# Calculate overall attrition statistics
total_employees = len(df)
employees_left = (df["Attrition"] == "Yes").sum()
attrition_rate = (employees_left / total_employees) * 100

print("\nOverall Attrition Analysis:")
print("Total Employees:", total_employees)
print("Employees Left:", employees_left)
print("Attrition Rate:", round(attrition_rate, 2), "%")

# Compare average salary by attrition status
salary_by_attrition = df.groupby("Attrition")["Monthly_Salary_INR"].mean()

print("\nAverage Salary by Attrition Status:")
print(salary_by_attrition.round(2))

# Analyze attrition by overtime status
overtime_analysis = df.groupby("Overtime").agg(
    Total_Employees=("Employee_ID", "count"),
    Employees_Left=("Attrition", lambda x: (x == "Yes").sum())
)

overtime_analysis["Attrition_Rate"] = (
    overtime_analysis["Employees_Left"]
    / overtime_analysis["Total_Employees"] * 100
).round(2)

print("\nAttrition Analysis by Overtime:")
print(overtime_analysis)

# Fill missing Job Satisfaction values with the median
job_satisfaction_median = df["Job_Satisfaction"].median()
df["Job_Satisfaction"] = df["Job_Satisfaction"].fillna(job_satisfaction_median)

print("\nMissing Job Satisfaction After Treatment:")
print(df["Job_Satisfaction"].isnull().sum())

# Visualize attrition rate by overtime status
overtime_analysis["Attrition_Rate"].plot(kind="bar")

plt.title("Attrition Rate by Overtime Status")
plt.xlabel("Overtime")
plt.ylabel("Attrition Rate (%)")
plt.xticks(rotation=0)
plt.tight_layout()

# Save the visualization
plt.savefig("Attrition_by_Overtime.png", dpi=300, bbox_inches="tight")

plt.show()