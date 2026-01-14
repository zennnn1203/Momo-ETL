# MoMo Top-Up Service Analysis (2020)

## Project Overview
This project analyzes MoMo's top-up service data for the year 2020. It involves an end-to-end ETL process, exploratory data analysis (EDA), user segmentation using the RFM model, and insights to improve marketing strategies and user retention.

## Technologies Used
- **Python** (Pandas, NumPy, Scikit-learn, Matplotlib, Seaborn)
- **Power BI** for data visualization and dashboard creation
- **MSSQL Server** for database management and data storage

## Key Steps in the Project

### 1. Data Collection and ETL
- **Extracted** transactional and user data from various sources.
- **Transformed** data using **Python (Pandas, NumPy)** by cleaning, handling missing values, and ensuring data consistency and accuracy.
- **Loaded** the cleaned data into **MSSQL Server** for further analysis.

### 2. Exploratory Data Analysis (EDA)
- Performed detailed analysis to uncover trends and insights:
  - **75% of transactions** were below 50,000 VND.
  - **50% of users** were in the 23-32 age range.
  - **50% of users** recharged with Viettel SIM cards.
  
- Visualized key metrics and trends using **Matplotlib** and **Seaborn**.

### 3. User Segmentation with RFM Model
- Applied **Recency, Frequency, and Monetary (RFM)** metrics to assess user behavior.
- Used **K-means clustering** to segment users into six distinct clusters based on transaction frequency, recency, and monetary value.
- Identified high-revenue opportunities, with low-moderate spending users (Cluster 0) contributing **30% of total revenue** despite representing only **15% of users**.

### 4. Data Visualization and Dashboards
- Developed interactive **Power BI** dashboards to visualize:
  - Key business metrics like transaction volume, user demographics, and spending behavior.
  - Performance trends, allowing for better business decisions.

### 5. Strategic Insights and Recommendations
- **Promotional Strategy:** Suggested offering discounts or cashback for top-ups above 50,000 VND to encourage higher-value transactions.
- **Targeted Marketing:** Focused on the **Vinaphone** user base, as it generated the highest average profit.
- **User Retention:** Noted that while new user growth was declining, repeat transactions from existing users were low. Recommended implementing loyalty programs and improving after-service policies.

