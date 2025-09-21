PROC SQL;
    CREATE TABLE work.monthly_sales AS
    SELECT 
        INTNX('MONTH', Date, 0) AS Month format=YYMMN6.,
        ProductCategory,
        SUM(SalesAmount) AS TotalSales
    FROM work.sales_fmt
    GROUP BY INTNX('MONTH', Date, 0), ProductCategory;
QUIT;

PROC SGPLOT DATA=work.monthly_sales;
    WHERE ProductCategory IN ("Fruits", "Dairy", "Bakery");
    SERIES X=Month Y=TotalSales / GROUP=ProductCategory MARKERS;
    XAXIS LABEL="Month";
    YAXIS LABEL="Total Sales (€)";
    TITLE "Monthly Sales Trends (Top Categories)";
RUN;