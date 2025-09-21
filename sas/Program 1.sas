PROC IMPORT DATAFILE="/home/u64242965/sasuser.v94/greengrocer_sales.csv"
	OUT=work.sales
    DBMS=CSV
    REPLACE;
    GETNAMES=YES;
RUN;

PROC PRINT DATA=work.sales (OBS=10);
    TITLE "Sample Sales Data";
RUN;