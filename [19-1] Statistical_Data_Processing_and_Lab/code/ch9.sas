/* ��9�� ppt */

/* SQL : ������ ���� ���, sas ���ν����Ӹ� �ƴ϶� data�ܰ� �Ϻ� ���൵ ����  
    1. ��� ��跮 ����/���� �ۼ�
    2. Į�� �߰�, ����, ���� 
    3. table, view ���� 
    4. ������ �˻�, ����, ���� */

/* �⺻ ��� 
   proc sql options;
   select - Į�� ����/��ǥ(,)�� ����/*�� ��� Į�� ���� 
   from - ���̺� ����
   where - �� ����. �˻� ����
   group by - ������ Į�� ������ ���.
   order by colmn [desc]; - ���� ����
   quit; */

/* ���� */

title1 '*** sqlug1: User guide chapter 1 examples***';
data employee;
input empnum empname $ empyears empcity $ 20-34
emptitle $ 36-45 empboss;
cards;
101 Herb 28 Ocean City president .
201 Betty 8 Ocean City manager 101
213 Joe 2 Virginia Beach salesrep 201
214 Jeff 1 Virginia Beach salesrep 201
215 Wanda 10 Ocean City salesrep 201
216 Fred 6 Ocean City salesrep 201
301 Sally 9 Wilmington manager 101
314 Marvin 5 Wilmington salesrep 301
318 Nick 1 Myrtle Beach salesrep 301
401 Chuck 12 Charleston manager 101
417 Sam 7 Charleston salesrep 401
;
run;
proc print data = employee;
run;
/* �� ����� �� ����? */
proc sql ;
title2 'CITY AND YEARS OF SERVICE';
select empname, empcity, empyears /* select �� ���� ������� ��� */
from employee 
where emptitle='salesrep'; /*�˻� ����*/
quit;

proc sql ;
title2 'CITY AND YEARS OF SERVICE';
title3 'Computed with PROC SQL';
select empcity, sum(empyears) as totyears /* sum(A) as B : A�� ���� B��� ���ο� Į������ ���� */
from employee
where emptitle='salesrep'
group by empcity; /*empcity ������ ������ �з�*/
order by totyears; /*totyears�� ������������ ����*/
quit;

/* <����> PROC SQL�� �ٸ� ������ ǥ���ϱ� */

title2 'CITY AND YEARS OF SERVICE';
title3 'Computed with PROC SUMMARY, SORT AND PRINT'; /* proc sql = proc summary, sort and print */
proc summary data=employee; /* sum ���ν��� */
where  emptitle='salesrep'; /* Ư�� ������ */
class empcity; /* empcity�� �з������� */
var empyears; /* ���� emyears�� ������ */
output out=sumyears sum=totyears; /* �� ����� sumyears�� �ϰ� sum�� totyears�� �̸� ���� */
run;
proc sort data=sumyears; 
by totyears; /* totyears�� �������� �������� ���� */
run;
proc print data=sumyears noobs;
var empcity totyears;
where _type_ = 1 ; /* _type_=0�� ��ü�ڷḦ �ǹ� */
run;

/* create�� <-create�� �����Ѵٰ� ��µ��� ����. 
   1. create view name as    ; - view�� ������ ���̺�� ���� ���̺���� �޸� �ڷḦ �����ϰ� ���� ���� 
   2. create table name as   ; */

/* view�� ���� */
proc sql ;
title2 'EMPLOYEES WHO RESIDE IN OCEAN CITY';
title3 " ";
create view ocity as 
select empname, empcity, emptitle, empyears /* �� Į������ ��� view ����. ���̺���� �޸� �ڷ� ���� ����. */
from employee
where empcity='Ocean City';
proc print data=ocity; /* create���� ��� ��� ���ϹǷ� proc print�� Ȯ�� */
sum empyears; /* �հ� ���� ��� */
run;

/* Į���� ���� 
    select a, b label = '����', c format = ����, ���� as new from table;
   Į���� ��ſ� ������ ���̰ų�, Į���� ���� �����ϰų� ���ο� Į���� ������ �� ��� */

data paper;
input author$1-8 section$9-16 title$17-43 @45 time TIME5. @52 duration;
format time TIME5.;  
label title='Paper Title';
cards;
Tom Testing Automated Product Testing 9:00 35
Jerry Testing Involving Users 9:50 30
Nick Testing Plan to test, test to plan 10:30 20
Peter Info SysArtificial intelligence 9:30 45
Paul Info SysQuery Languages 10:30 40
Lewis Info SysQuery Optimisers 15:30 25
Jonas Users Starting a Local User Group 14:30 35
Jim Users Keeping power users happy 15:15 20
Janet Users keeping everyone informed 15:45 30
Marti GraphicsMulti-dimensional graphics 16:30 35
Marge GraphicsMake your own point! 15:10 35
Mike GraphicsMaking do without color 15:50 15
Jane GraphicsPrimary colors, use em! 16:15 15
Jost Foreign Languages Issues 11:15 .
;
run;

title2 'papers to be presented';
proc sql ;
select *
from paper; /* proc print�� ������ ��� */

title2 'how long will it take?';
proc sql;
select author, title, time, duration, time + duration*60 as endtime /* endtime �ʴ���. *60�ؼ� �ʴ����� ������ */
from paper;

title2 'How long will it take?';
proc sql ;
select author, title, time, duration label='How Long it Takes', /* �� ���� */
time + duration*60 as endtime FORMAT=TIME5. /* ���� �������� �ð� ������ ��� */
from paper;


title2 'Papers presented in the morning';
proc sql ;
select author, title, time, duration label='How Long it Takes',
time + duration*60 as endtime FORMAT=TIME5.
from paper
where time < '12:00't; /* time�� �ð� �����̹Ƿ� '12:00'�� ���� t�� �ٿ��� �� ���� ���� */

/* table ���� */     

/* create table�� ���̺� �������ϰ� ������� ����.
 1) ���̺귯���� ���� Ȯ���ϰų� 
2) select * from ���� ���̺� �̸� ; �� �������� �߰��ϸ� ���â�� ��� ��. */

create table p2 like paper; /* paper ���̺��� Į���̸��� ������ ���̺��� �����ϴµ� �ο�(����)�� ����  �ȵ�. */

create table p3 as select * from paper
where time > '12:00't; /* paper ���̺��� Į���� ������ ���̺��� �����ϴµ� �ο�(����)�� ���Ե�. ���� ��µ� �� */

create table count(section CHAR(20), paper NUM);  /* Ư�� Į���� ������ ���̺� ����. Į�� �̸��� ���ĵ� ���� */

/* ������ �߰��ϱ� */

proc sql;
insert into paper(author, title, time) /* ���̺� paper�� 3���� Į�� �߰� */
values(��jost��, ��Foreign Language lssues��, ��11:15��t); /* �߰��� Į���� ���� �� �߰� */
title2 ��After inserting jost��;
select * from paper; /* ��ü ��� */

proc sql;
create table counts(section CHAR(20), papers NUM); /* Ư�� Į���� ������ ���̺� ���� */
insert into counts /* �߰��ϴ� Į���� ���� */
select section, COUNT(*) from paper /* COUNT �Լ��� ���� ī��Ʈ�� ����� ����.*/
group by section; /* section�� ���� �׷�ȭ�Ǿ� �����Ƿ� section���� ���� ���������� ���� ī��Ʈ */
title2 ��Papers counted by section��;
select * from counts;

proc sql;
create table counts(section CHAR(20), papers NUM);
insert into counts 
values(��Graphics��, 4)
values(��Info Sys��, 3)
values(��Testing��, 2)
values(��Users��, 3)
values(����, 1); /* ���� 5�� �߰� */
title2 ��Before Deleting FROM Counts��;
select * from counts;

/* ������ �����ϱ� */

proc sql;
delete from counts
where section IS null;
title2 ��After Deleting WHERE section is null��;
select * from counts;

proc sql;
delete from counts
where papers=(SELECT MIN(papers) from counts); /* counts ���̺��� papers ���� ���� ���� ������ ���� */
title2 ��After Deleting section with fewest papers��;
select * from counts;

/* <PROC SQL> 
   1. �⺻ ����
   2. ���� �ܰ� <=> �ϳ��� SQL
   3. Į���� ����
   4. view�� ����
   5. table�� ����
   6. ������ ����
   7. ������ ���� */





