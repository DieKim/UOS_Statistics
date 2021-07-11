/* Q7.2 */

/* (1) ������ �Է� �� �α׺�ȯ */
data depart;
   infile 'C:\Users\USER\Desktop\depart.txt'; 
   input z @@;
   date=intnx('month','1jan84'd,_n_-1);  
   format date Monyy.; 
run; 

data lndepart; 
   set depart; 
   logz=log(z); /* �α׺�ȯ */ 
run;

/* (2) �������� �� �ð迭�� */
data depart; 
   set lndepart; 
   dif1_12=dif12(logz); /* �������� */
run;
proc sgplot; 
   series x=date y=dif1_12 ; 
   xaxis values=('1jan85'd to '1jan89'd by year) 
   label="date"; yaxis label="��12 ln Zt";  
run; quit;

/* (3) 1���߼� ���� �� �ð迭�� */
data depart; 
   set lndepart; 
   dif1_12=dif12(logz); /* �������� */
   dif1=dif(dif1_12); /* 1�� ���� */
run;
proc sgplot; 
   series x=date y=dif1 ; 
   xaxis values=('1jan85'd to '1jan89'd by year) 
   label="date"; yaxis label="��12�� ln Zt"; 
   refline 0/ axis=y; 
run; quit;

/* �� 7-4 */
 data depart; 
   set lndepart; 
   dif1=dif(logz); /* 1�� ���� */  
   dif1_12=dif12(dif1); /* �������� */
run;
  proc sgplot; 
   series x=date y=dif1_12 ; 
	xaxis values=('1jan85'd to '1jan89'd by year) label="date"; 
    yaxis label="�ԡ�12 ln Zt";  
   refline 0 / axis=y;  
run; quit; 

