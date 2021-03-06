/* Q1 */
data ex1;
input year quarter CE MS @@;
cards;
1952 1 214.6 159.3 1952 2 217.7 161.2 1952 3 219.6 162.8 1952 4 227.2 164.6
1953 1 230.9 165.9 1953 2 233.3 167.9 1953 3 234.1 168.3 1953 4 232.3 169.7 
1954 1 233.7 170.5 1954 2 236.5 171.6 1954 3 238.7 173.9 1954 4 243.2 176.1
1955 1 249.4 178.0 1955 2 254.3 179.1 1955 3 260.9 180.2 1955 4 263.3 181.2
1956 1 265.6 181.6 1956 2 268.2 182.5 1956 3 270.4 183.3 1956 4 275.6 184.3
; run;
proc reg data=ex1;
model CE=MS/dw dwprob;
run; quit;

/* Q2 */
proc import datafile='C:\Users\USER\Desktop\200930_bookstore.xls' dbms=xls replace
out=ex2;
namerow=1;
startrow=2;
getnames=yes;
run;
proc reg data=ex2;
model Sales = Adver/dw dwprob;
run; quit;
