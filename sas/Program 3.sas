DATA work.high_profit;
    SET work.sales_fmt;
    IF Profit > 300;
RUN;

PROC PRINT DATA=work.high_profit (OBS=10);
    TITLE "High-Profit Transactions (> €300)";
RUN;