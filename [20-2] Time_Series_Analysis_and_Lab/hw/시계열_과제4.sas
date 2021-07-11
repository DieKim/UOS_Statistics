/** EXAMPLE 4.1 **/
data food;
  infile 'C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\food.txt'; input food @@;
  date=intnx('month','1jan80'd,_n_-1); /* food.txt; ���� �ڷ� */
  format date monyy.; t+1; /* t+1; �ε��� */
  mon=month(date);
     if mon=1 then i1=1; else i1=0;
     if mon=2 then i2=1; else i2=0;
     if mon=3 then i3=1; else i3=0;
     if mon=4 then i4=1; else i4=0;
     if mon=5 then i5=1; else i5=0;
     if mon=6 then i6=1; else i6=0;
     if mon=7 then i7=1; else i7=0;
     if mon=8 then i8=1; else i8=0;
     if mon=9 then i9=1; else i9=0;
     if mon=10 then i10=1; else i10=0;
     if mon=11 then i11=1; else i11=0;
     if mon=12 then i12=1; else i12=0; run;
/** food �ڷῡ �����߼����� �����ϱ� **/
proc reg data=food ;
  model food= t/dw; /* dw; DW ��跮 �ɼ� */
  output out=trendata p=trend ;
  id date; run;
data adtrdata; 
  set trendata; 
  adjtrend=food/trend; run; /* adjtrend; �߼� ���� */
/** food �ڷῡ �ڱ�ȸ�Ϳ������� �����ϱ� **/
proc autoreg data=adtrdata;
  model adjtrend=i1-i12/noint nlag=13 dwprob backstep; 
  output out=seasdata p=seasonal; run;
data all; 
  set seasdata; 
  keep date food trend seasonal irregular fitted;
  irregular=adjtrend/seasonal;
  fitted=trend*seasonal; run;
proc print data=all; 
  var date food trend seasonal irregular fitted; run;
proc arima data=all; 
  identify var= irregular nlag=12; run; 
/** [�׸� 4-1]; �߼����� by �߼������� ���� ���ع� cf ���ð迭 **/ 
proc sgplot data=all;
  series x=date y=food/  lineattrs=(pattern=1 color=blue); /* ���ð迭 */
  series x=date y=trend/ lineattrs=(pattern=2 color=black); run; /* �߼����� */
/** [�׸� 4-2]; �������� by �߼������� ���� ���ع� **/ 
proc sgplot data=all;
  series x=date y=seasonal; run; /* �������� */ 
/** [�׸� 4-3]; �ұ�Ģ���� by �߼������� ���� ���ع�  **/ 
proc sgplot data=all;
  series x=date y=irregular; /* �ұ�Ģ���� */
  refline 1.0/ axis=y; run;
/** [�׸� 4-4]; ���� by �߼������� ���� ���ع� **/ 
proc sgplot data=all;
  series x=date y=food/  lineattrs=(pattern=1 color=blue); /* ���ð迭 */
  series x=date y=fitted/ lineattrs=(pattern=2  color=black); run; /* �������� */

/** EXAMPLE 4.3 **/
data food;
  infile 'C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\food.txt'; input food @@;
  date=intnx('month','1jan80'd,_n_-1);
  format date monyy.; t+1;
  mon=month(date); run;
/** expand ������ �̿��Ͽ� ���������� ���� ���е��� �����ϱ� **/
proc expand data=food out=food2; /* ���� by �̵���չ� */
  convert food=tc/transformout=(cda_tc 12);
  convert food=s/transformout=(cda_s 12);  
  convert food=i/transformout=(cda_i 12);
  convert food=sa/transformout=(cda_sa 12); run;
/** [�׸� 4-7] **/ 
proc sgplot data=food2;
  series x=date y=food/  lineattrs=(pattern=1 color=black); /* ���ð迭 */
  series x=date y=tc/ lineattrs=(pattern=2 color=blue); /* �߼�*��ȯ���� */ 
  xaxis values=('1jan80'd to '1jan92'd by year); run;
/** [�׸� 4-8] **/ 
proc sgplot data=food2;
  series x=date y=food/  lineattrs=(pattern=1 color=black); /* ���ð迭 */
  series x=date y=s/ lineattrs=(pattern=2 color=blue); /* �������� */
  xaxis values=('1jan80'd to '1jan92'd by year); run;
/** [�׸� 4-9] **/ 
proc sgplot data=food2;
  series x=date y=food/  lineattrs=(pattern=1 color=black); /* ���ð迭 */
  series x=date y=i/ lineattrs=(pattern=2 color=blue); /* �ұ�Ģ���� */
  xaxis values=('1jan80'd to '1jan92'd by year); run;
/** [�׸� 4-10] **/ 
proc sgplot data=food2;
  series x=date y=food/  lineattrs=(pattern=1 color=black); /* ���ð迭 */
  series x=date y=sa/ lineattrs=(pattern=2 color=blue); /* �������� */
  xaxis values=('1jan80'd to '1jan92'd by year); run;

/**  EXAMPLE 4.4  **/
data food;
  infile 'C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\food.txt';
  input food @@;
  date=intnx('month','1jan80'd,_n_-1);
  format date monyy.; t+1;
  mon=month(date); run;
/** X12 �������� X11 ����� ���� ���� ���� ���е��� �����ϱ� **/
proc X12 data=food seasons=12 start=jan1980;
  var food;
  x11; /* X-12 ARIMA �� X11�� ���� �������� */
  output out=foodout a1 d10 d11 d12 d13;  run;
/** <ǥ 4-7> **/
proc print data=foodout; run;
/** [�׸� 4-11]~[�׸� 4-14] �׸��� **/
data foodout; set foodout(rename=(_date_=date food_a1=food food_d10=d10 
  food_d11=d11 food_d12=d12 food_d13=d13 ));
  label food=" "  d10=" "  d11=" "  d12=" "  d13=" " ; run;
/** [�׸� 4-11] **/ 
title "Final seasonal factors";
proc sgplot data=foodout;
  series x=date y=d10; run;
/** [�׸� 4-12] **/ 
title "Original time series vs Seasonally adjusted series";
proc sgplot data=foodout;
  series x=date y=food/  lineattrs=(pattern=1 color=blue); 
  series x=date y=d11/ lineattrs=(pattern=2 color=black); run;
/** [�׸� 4-13] **/ 
title "Original time series vs Trend cycle";
proc sgplot data=foodout;
  series x=date y=food/  lineattrs=(pattern=1 color=blue); 
  series x=date y=d12/ lineattrs=(pattern=2 color=black); run;
/** [�׸� 4-14] **/ 
title "Irregular component";
proc sgplot data=foodout;
  series x=date y=d13; 
  refline 1.0/ axis=y; run;
proc arima data=foodout; /* �ڱ������ Ȯ�� */
  identify var=d13 nlag=24; run; quit;
