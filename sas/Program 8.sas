PROC SQL;
    CREATE TABLE work.country_sales AS
    SELECT 
        Country,
        SUM(SalesAmount) AS TotalSales,
        SUM(Profit) AS TotalProfit
    FROM work.sales_locations
    GROUP BY Country
    ORDER BY TotalSales DESC;
QUIT;

PROC PRINT DATA=work.country_sales;
    TITLE "Total Sales and Profit by Country";
RUN;