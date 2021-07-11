/* ��6�� ppt */

proc print data = a; /* print ���� ȣ��. �ڷ� a �μ� */
run; 
proc means data = b n mean std; /* means �������� n, mean, std ���� �ɼ� */
run; /* meanas ������ ȣ���Ͽ� �ڷ� b�� ������(n), ���(mean), ǥ������(std)��� */

data one;
input x total @@;
format total dallar10.2;
datalines;
3 28982 5 2849 
run;
proc print data = one;
format total dollar10.2; /* ������� ���� */
run;

proc print data = class;
var in_num name credit; /* ����� ���ϴ� ���� ���� */
run;
proc means data = class;
var _numeric_; /* ������ */
run;

data a;
input country $ city $ month number;
cards;
Korea Seoul 1 5024
France Paris 2 1200
Korea Seoul 2 4214
France Paris 3 2354
Korea Busan 3 1347
Korea Seoul 4 6635
Korea Busan 4 987
France Paris 4 3308
Korea Seoul 5 3375
Korea Busan 5 334
France Paris 5 893
run;
proc print data = a;
run; /* �⺻ ���(1) */
proc sort data = a;
by country city;
run; /* country�������� city ���� */
proc print data = a;
by country;
run; /* ���ĵ� ���� country�� ���ؼ� ���(2). sort �ܰ� �̿��� by�����̹Ƿ� �������� ���� ������ �м�.  */
proc print data = a;
by country city;
run; /* sort�ܰ� �̿��� by������ ��� ���غ����� ������ �м�,  ���(3) */
proc print data = a;
by city;
run; /* �ֿ켱 ���غ����� city�� �ƴϹǷ� ����. city �������� sort ���� ���� �ʿ� */

data b;
input country $ city $ month number;
cards;
Korea Seoul 1 5024
France Paris 2 1200
Korea Seoul 2 4214
France Paris 3 2354
Korea Busan 3 1347
Korea Seoul 4 6635
Korea Busan 4 987
France Paris 4 3308
Korea Seoul 5 3375
Korea Busan 5 334
France Paris 5 893
run;
proc sort data = b out = sorted_b; /* by���� �������� ������ ����� ���ο� �����ͼ����� ���� */
by country descending city; /* country ��������, city �������� */
run;
proc print data = sorted_b;
run;

proc anova data = b; /* anova - �л� �м� */
class city; /* class - �м��� �ʿ��� �з� ����, model ���庸�� ����Ǿ�� �� */
model number = city; /* ���Ӻ��� = �������� �� */
run;
proc print data = b;
id country; /* obs ��� country ���� ��� */
var _all_ ; /* id������ �ߺ� �����Ǹ� 2�� ��� */
run;

proc print data = b label; /* label ��� �� �ɼ� ���� �ʿ� */ 
id country;
var city number;
label number = "# of Car Accidents " country = "Country"; /* ��ĭ���� 256��, �ѱ� 128�� */
label city = "Big City"; /* label���� ������ �ᵵ ��� ����. �� ���忡 ���ƽᵵ �������. */
run;
proc print data = b split='*'; /* ���� ����. label �ɼ� ���� ���� */
id country;
var city number;
label number='# of * Car * Accidents' country='Country' city='Big City';
run;

proc reg; /*ȸ�ͺм�*/
model y = x1 x2;
run;
quit;
proc anova data = b; /*�л�ϼ�*/
class = city;
model number = city;
run;
quit;
options validvarname = any;
proc means data = b;
var number;
output out = auto mean=average std=ǥ������; /* output �������� out ������ �� �̸��� sasŰ���� �̸� ���� */
run;
proc print data = auto;
run; /* _TYPE_�� output ������ ����Ǵ� sas �ڷ��� ����. �ڵ�����
            _FREQ_�� output ���忡 ���� ���ο� ������ ��µ� keyword */

/* plot, anova, glm, reg �� ��ȭ�� ������ ���� �� Quit ���� */

proc print data = b;
where city = 'seoul';
run;
proc print data = b;
where month in (1,3,5);
run;
proc print data = b;
where number>3000 & city^='busan';
run;
proc print label;
var jobcode salary;
label salary = 'annual salary';
where jobcode = 'pilot2';
run;
proc means;
var salary;
where lastname = 'smith';
where also month = 1; /* where ���� 2���� �ȵ�. where also�� ���� */
run;
proc means;
var salary;
where lastname = 'smith' & month = 1; /* Ȥ�� and�� ���� */

