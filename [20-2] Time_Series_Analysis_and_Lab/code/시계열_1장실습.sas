/* 1�� �ð迭�ڷ� */

/* (1)  �ұ�Ģ�������� ������ �ð迭 */
data fig1_1;
  do t=1 to 100;
    z=5000+20*rannor(1234); /* Zt=5000+����, ����~N(0, 20) */
    output;
  end; run;
data fig1_1;
  set fig1_1;
  date=intnx('month', '1jan80'd,_n_-1); /* ���� �ð� ���� ���� */
  format date monyy.; run;
proc sgplot; /* �ð迭��; �ұ�Ģ���� */
  series x=date y=z;
  refline 5000/ axis=y; run;

  /* (2) �߼������� ���� �ð迭 */
  data fig1_2;
  do t=1 to 100;
    x=0.5*t; /* �������� */
    z=0.5*t+rannor(1234); /* Zt = 0.5 + t + ����, ����~N(0,1) */
    output;
  end; run;
data fig1_2; set fig1_2;
  date=intnx('month', '1jan80'd,_n_-1);
  format date monyy.; run;
proc sgplot; 
  series x=date y=z/ lineattrs=(color=blue); /* Ȯ������; Ȯ�������� O */
  series x=date y=x/ lineattrs=(color=red); /* ��������; Ȯ�������� X */
  reg x=date y=z; /* �߼���; ���������̶� ���� ��? */
run;

/* (3) ���������� ���� �ð迭 */
data fig1_3;
  do t=1 to 120;
    a=rannor(2483); /* Ȯ������ */
    z=10+3*sin((2*3.14*t)/12)+0.8*a; /* �������� by �ﰢ�Լ� */
    output;
  end; run;
data fig1_3; set fig1_3;
  date=intnx('month', '1jan85'd,_n_-1);
  format date monyy.; run;
proc sgplot; /* �ð迭��; �������� Ȯ�� */
  series x=date y=z; run;

/* (4) �߼�����+���������� ���� �ð迭 */
data fig1_4; /* depart.txt */
  infile 'C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\depart.txt';
  input z @@;
  logz=log(z); /* �̺л꼺 -> �α׺�ȯ */
  date=intnx('month', '1jan84'd,_n_-1);
  format date monyy.;
  x=2.701573+0.000409*date; run; 
proc sgplot;
  series x=date y=logz/ lineattrs=(color=blue); /* �α׺�ȯ�� �ð迭 */
  series x=date y=x/ lineattrs=(color=black); /* ������(=���հ�, ������); �����߼� */
run;

/* (5) �߼�����+��������+�̺л꼺�� ���� �ð迭 (-> �α׺�ȯ) */
data fig1_5; /* koreapass.txt */
  infile 'C:\Users\USER\Desktop\����\3�г� 2�б�\�ð迭�м��׽ǽ�\�����ڷ�\��5�� �ð迭�м� data\koreapass.txt';
  input z @@;
  date=intnx('month','1jan81'd,_n_-1);
  format date monyy.; run;
proc sgplot;
  series x=date y=z; run;

/* (6) �߼����� 2���� �ð迭 (-> ��Ȱ��) */
data fig1_6;
  do t=1 to 120;
    a=rannor(4321);
    if t le 60 then x=0.5*t; /* �߼� 1 */
    else x=2*(t-46); /* �߼� 2 */
    z=x+a; output;
  end; run;
data fig1_6;
  set fig1_6;
  date=intnx('month','1jan85'd,_n_-1);
  format date monyy.; run;
proc sgplot; /* �ð迭��; �߼��� 2�� Ȯ�� */
  series x=date y=z; 
  refline '1jan90'd/ axis=x; run;
