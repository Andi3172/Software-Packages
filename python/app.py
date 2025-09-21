import streamlit as st
import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
import statsmodels.api as sm
from sklearn.preprocessing import StandardScaler

@st.cache_data
def load_data():
    sales = pd.read_csv("../data/greengrocer_sales.csv")
    locations = pd.read_csv("../data/greengrocer_locations.csv")
    customers = pd.read_csv("../data/greengrocer_customers.csv")
    return sales, locations, customers

sales, locations, customers = load_data()

st.title("GreenGrocer Analytics Dashboard")

# 1. Data Preview
st.header("1. Data Preview")
st.write("Sales Data:", sales.head())

# 2. Geospatial Map
st.header("2. Store Locations")
gdf = gpd.GeoDataFrame(
    locations,
    geometry=gpd.points_from_xy(locations.Longitude, locations.Latitude)
)
gdf = gdf.rename(columns={"Latitude": "lat", "Longitude": "lon"})
st.map(gdf)

# 3. Data Cleaning
st.header("3. Handle Missing/Extreme Values")
st.write("Missing values before cleaning:", sales.isnull().sum())
sales_clean = sales.fillna({"Customers": sales["Customers"].median()})
st.write("Missing values after cleaning:", sales_clean.isnull().sum())

# 4. Encoding & Scaling
st.header("4. Preprocessing")
sales_clean["Category_Code"] = sales_clean["ProductCategory"].astype("category").cat.codes
st.write("Encoded Categories:", sales_clean[["ProductCategory", "Category_Code"]].drop_duplicates())

# 5. Statistical Analysis
st.header("5. Sales Statistics")
monthly_sales = sales_clean.groupby(
    [pd.to_datetime(sales_clean["Date"]).dt.to_period("M"), "ProductCategory"]
)["SalesAmount"].sum().unstack()
st.line_chart(monthly_sales)

# 6. Clustering (Customer Segmentation)
st.header("6. Customer Clustering (K-Means)")
X = customers[["Age", "Income"]]
kmeans = KMeans(n_clusters=3).fit(X)
customers["Cluster"] = kmeans.labels_
st.scatter_chart(customers, x="Age", y="Income", color="Cluster")

# 7. Regression Analysis
sales_clean["Weekday"] = pd.to_datetime(sales_clean["Date"]).dt.dayofweek
sales_clean["Month"] = pd.to_datetime(sales_clean["Date"]).dt.month
sales_clean["Customer_Spend"] = sales_clean["SalesAmount"] / sales_clean["Customers"]

X = sm.add_constant(sales_clean[["Customers", "Category_Code", "Weekday", "Customer_Spend"]])
y = sales_clean["SalesAmount"]

scaler = StandardScaler()
X_scaled = scaler.fit_transform(sales_clean[["Customers", "Category_Code", "Weekday", "Customer_Spend"]])
X_scaled = sm.add_constant(X_scaled)
model_scaled = sm.OLS(y, X_scaled).fit()

st.subheader("Improved Regression Results")
st.text(model_scaled.summary().as_text())

# 8. Download Processed Data
st.download_button(
    label="Download Cleaned Data",
    data=sales_clean.to_csv(index=False),
    file_name="greenGrocer_clean.csv"
)
