DATA work.sales_fmt;
	SET work.sales_fmt;
	Customers_num = INPUT(Customers, 8.);
	DROP Customers;
	Rename Customers_num = Customers;
RUN;

PROC MEANS DATA=work.sales_fmt MEAN MEDIAN STD MAXDEC=2;
    CLASS ProductCategory;
    VAR SalesAmount Profit Customers;
    TITLE "Summary Statistics by Product Category";
RUN;