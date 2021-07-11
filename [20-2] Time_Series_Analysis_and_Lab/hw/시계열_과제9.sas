/* ��8-6 */

/* ������ �ҷ����� */
data gas;
   infile "C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\gas.txt";
   input gas co2 @@; time+1; run;

/* �ڷ��� �ð迭�� */
proc sgplot data=gas;
   series x=time y=gas ; xaxis label="time"; yaxis label="gas"; run;

/* �����ĺ�, �������, �����м� */
proc arima;
   identify var=gas nlag=24; run;
   estimate p=3 method=cls plot; run;
   estimate p=3 method=ml noint plot; run;
   forecast lead=0 out=res; run; quit;

/* ������ �ð迭�� */
data res; set res; time=_n_; run; 
proc sgplot;
   series x=time y=residual ; xaxis label="time"; 
   yaxis label="residual"; refline 0 / axis=y; run;

/* ������ ����м� */
proc arima; identify var=residual nlag=24; run; quit;

/* �������� */
proc arima data=gas;
   identify var=gas nlag=24 noprint; run;
   estimate p=4; run; /* AR(4) */
   estimate p=3 q=1; run;  /* ARMA(3,1) */
   estimate p=3 q=1 noint plot; run; /* ����� ���� */
run; quit; 
