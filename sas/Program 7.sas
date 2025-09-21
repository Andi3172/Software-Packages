DATA work.sales_with_tax;
    SET work.sales_fmt;
    ARRAY revenue[2] SalesAmount Profit;
    DO i=1 TO 2;
        revenue[i] = ROUND(revenue[i] * 1.10, 0.01);
    END;
    DROP i;
RUN;

PROC PRINT DATA=work.sales_with_tax (OBS=10);
    TITLE "Sales Data with 10% Tax Applied";
RUN;