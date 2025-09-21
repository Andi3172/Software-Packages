PROC FORMAT;
    VALUE storefmt
        1 = "Berlin"
        2 = "Paris"
        3 = "Madrid"
        4 = "Rome"
        5 = "Amsterdam"
        6 = "Vienna"
        7 = "Brussels"
        8 = "Lisbon"
        9 = "Dublin"
        10 = "Athens";
RUN;

DATA work.sales_fmt;
    SET work.sales;
    FORMAT StoreID storefmt.;
RUN;