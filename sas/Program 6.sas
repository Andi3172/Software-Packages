PROC IMPORT DATAFILE="/home/u64242965/sasuser.v94/greengrocer_locations.csv"
    OUT=work.locations
    DBMS=CSV
    REPLACE;
    GETNAMES=YES;
RUN;

PROC SORT DATA=work.sales_fmt OUT=work.sales_sorted;
    BY StoreID;
RUN;

PROC SQL;
    CREATE TABLE work.sales_locations AS
    SELECT a.*, b.City, b.Country, b.Latitude, b.Longitude
    FROM work.sales_fmt a
    LEFT JOIN work.locations b
    ON a.StoreID = b.StoreID;
QUIT;