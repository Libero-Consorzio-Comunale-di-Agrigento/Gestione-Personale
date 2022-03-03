set feedback off
set define off
prompt Dropping SCAF_LFIN_2007...
drop table SCAF_LFIN_2007;
prompt Creating SCAF_LFIN_2007...
create table SCAF_LFIN_2007
(
  DAL           DATE not null,
  AL            DATE,
  SCAGLIONE     NUMBER(12,2) not null,
  COD_SCAGLIONE VARCHAR2(2) not null,
  NUMERO_FASCIA NUMBER(3) not null
)
;

prompt Loading SCAF_LFIN_2007...
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 12600, 'B', 2);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 12700, 'B', 3);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 12800, 'B', 4);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 12900, 'B', 5);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13000, 'B', 6);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13100, 'B', 7);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13200, 'B', 8);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13300, 'B', 9);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13400, 'B', 10);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13500, 'B', 11);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13600, 'B', 12);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13700, 'B', 13);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13800, 'B', 14);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13900, 'B', 15);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14000, 'B', 16);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14100, 'B', 17);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14200, 'B', 18);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14300, 'B', 19);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14400, 'B', 20);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14500, 'B', 21);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14600, 'B', 22);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14700, 'B', 23);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14800, 'B', 24);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14900, 'B', 25);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15000, 'B', 26);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15100, 'B', 27);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15200, 'B', 28);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15300, 'B', 29);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15400, 'B', 30);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15500, 'B', 31);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15600, 'B', 32);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15700, 'B', 33);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22278.95, 'C', 1);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25230.54, 'C', 2);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28182.69, 'C', 3);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31135.43, 'C', 4);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34087.61, 'C', 5);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37040.33, 'C', 6);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39991.36, 'C', 7);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42944.68, 'C', 8);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45895.67, 'C', 9);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48848.99, 'C', 10);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51801.15, 'C', 11);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24246.48, 'D', 1);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27198.63, 'D', 2);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30151.94, 'D', 3);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33102.97, 'D', 4);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36055.14, 'D', 5);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39006.72, 'D', 6);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41960.62, 'D', 7);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44912.76, 'D', 8);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47866.08, 'D', 9);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50817.67, 'D', 10);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 11813.55, 'E', 1);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14766.3, 'E', 2);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17719.04, 'E', 3);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20670.63, 'E', 4);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23622.78, 'E', 5);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26576.1, 'E', 6);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29528.26, 'E', 7);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32479.85, 'E', 8);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35431.43, 'E', 9);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38384.17, 'E', 10);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41336.92, 'E', 11);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44289.67, 'E', 12);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47242.4, 'E', 13);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50195.13, 'E', 14);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53147.89, 'E', 15);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56100.61, 'E', 16);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 99999999, 'E', 17);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13781.66, 'F', 1);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16734.99, 'F', 2);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19685.99, 'F', 3);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22638.15, 'F', 4);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25592.05, 'F', 5);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28544.2, 'F', 6);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31496.95, 'F', 7);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34447.97, 'F', 8);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37400.7, 'F', 9);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40353.44, 'F', 10);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43306.19, 'F', 11);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46257.77, 'F', 12);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49211.08, 'F', 13);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52163.83, 'F', 14);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55116.56, 'F', 15);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58069.89, 'F', 16);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21655.84, 'G', 1);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24606.26, 'G', 2);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27559.58, 'G', 3);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30511.74, 'G', 4);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33464.49, 'G', 5);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36416.64, 'G', 6);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39368.81, 'G', 7);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42321.54, 'G', 8);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45272.56, 'G', 9);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48225.88, 'G', 10);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51178.03, 'G', 11);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54130.78, 'G', 12);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57082.94, 'G', 13);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60036.27, 'G', 14);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62990.15, 'G', 15);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65941.73, 'G', 16);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23622.78, 'H', 1);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26576.1, 'H', 2);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29528.26, 'H', 3);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32479.85, 'H', 4);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35431.43, 'H', 5);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38384.17, 'H', 6);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41336.92, 'H', 7);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44289.67, 'H', 8);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47242.99, 'H', 9);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50195.13, 'H', 10);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53146.15, 'H', 11);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56098.31, 'H', 12);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59050.47, 'H', 13);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62002.06, 'H', 14);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64953.07, 'H', 15);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67904.65, 'H', 16);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 12500, 'B', 1);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15800, 'B', 34);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15900, 'B', 35);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16000, 'B', 36);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16100, 'B', 37);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16200, 'B', 38);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16300, 'B', 39);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16400, 'B', 40);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16500, 'B', 41);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16600, 'B', 42);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16700, 'B', 43);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16800, 'B', 44);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16900, 'B', 45);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17000, 'B', 46);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17100, 'B', 47);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17200, 'B', 48);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17300, 'B', 49);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17400, 'B', 50);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17500, 'B', 51);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17600, 'B', 52);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17700, 'B', 53);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17800, 'B', 54);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17900, 'B', 55);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18000, 'B', 56);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18100, 'B', 57);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18200, 'B', 58);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18300, 'B', 59);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18400, 'B', 60);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18500, 'B', 61);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18600, 'B', 62);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18700, 'B', 63);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18800, 'B', 64);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18900, 'B', 65);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19000, 'B', 66);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19100, 'B', 67);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19200, 'B', 68);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19300, 'B', 69);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19400, 'B', 70);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19500, 'B', 71);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19600, 'B', 72);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19700, 'B', 73);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19800, 'B', 74);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19900, 'B', 75);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20000, 'B', 76);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20100, 'B', 77);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20200, 'B', 78);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20300, 'B', 79);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20400, 'B', 80);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20500, 'B', 81);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20600, 'B', 82);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20700, 'B', 83);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20800, 'B', 84);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20900, 'B', 85);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21000, 'B', 86);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21100, 'B', 87);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21200, 'B', 88);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21300, 'B', 89);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21400, 'B', 90);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21500, 'B', 91);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21600, 'B', 92);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21700, 'B', 93);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21800, 'B', 94);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21900, 'B', 95);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22000, 'B', 96);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22100, 'B', 97);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22200, 'B', 98);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22300, 'B', 99);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22400, 'B', 100);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22500, 'B', 101);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22600, 'B', 102);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22700, 'B', 103);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22800, 'B', 104);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22900, 'B', 105);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23000, 'B', 106);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23100, 'B', 107);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23200, 'B', 108);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23300, 'B', 109);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23400, 'B', 110);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23500, 'B', 111);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23600, 'B', 112);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23700, 'B', 113);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23800, 'B', 114);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23900, 'B', 115);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24000, 'B', 116);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24100, 'B', 117);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24200, 'B', 118);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24300, 'B', 119);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24400, 'B', 120);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24500, 'B', 121);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24600, 'B', 122);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24700, 'B', 123);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24800, 'B', 124);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24900, 'B', 125);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25000, 'B', 126);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25100, 'B', 127);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25200, 'B', 128);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25300, 'B', 129);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25400, 'B', 130);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25500, 'B', 131);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25600, 'B', 132);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25700, 'B', 133);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25800, 'B', 134);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25900, 'B', 135);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26000, 'B', 136);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26100, 'B', 137);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26200, 'B', 138);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26300, 'B', 139);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26400, 'B', 140);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26500, 'B', 141);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26600, 'B', 142);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26700, 'B', 143);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26800, 'B', 144);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26900, 'B', 145);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27000, 'B', 146);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27100, 'B', 147);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27200, 'B', 148);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27300, 'B', 149);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27400, 'B', 150);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27500, 'B', 151);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27600, 'B', 152);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27700, 'B', 153);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27800, 'B', 154);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27900, 'B', 155);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28000, 'B', 156);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28100, 'B', 157);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28200, 'B', 158);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28300, 'B', 159);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28400, 'B', 160);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28500, 'B', 161);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28600, 'B', 162);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28700, 'B', 163);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28800, 'B', 164);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28900, 'B', 165);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29000, 'B', 166);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29100, 'B', 167);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29200, 'B', 168);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29300, 'B', 169);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29400, 'B', 170);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29500, 'B', 171);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29600, 'B', 172);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29700, 'B', 173);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29800, 'B', 174);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29900, 'B', 175);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30000, 'B', 176);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30100, 'B', 177);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30200, 'B', 178);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30300, 'B', 179);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30400, 'B', 180);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30500, 'B', 181);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30600, 'B', 182);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30700, 'B', 183);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30800, 'B', 184);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30900, 'B', 185);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31000, 'B', 186);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31100, 'B', 187);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31200, 'B', 188);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31300, 'B', 189);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31400, 'B', 190);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31500, 'B', 191);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31600, 'B', 192);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31700, 'B', 193);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31800, 'B', 194);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31900, 'B', 195);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32000, 'B', 196);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32100, 'B', 197);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32200, 'B', 198);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32300, 'B', 199);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32400, 'B', 200);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32500, 'B', 201);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32600, 'B', 202);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32700, 'B', 203);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32800, 'B', 204);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32900, 'B', 205);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33000, 'B', 206);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33100, 'B', 207);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33200, 'B', 208);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33300, 'B', 209);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33400, 'B', 210);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33500, 'B', 211);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33600, 'B', 212);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33700, 'B', 213);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33800, 'B', 214);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33900, 'B', 215);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34000, 'B', 216);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34100, 'B', 217);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34200, 'B', 218);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34300, 'B', 219);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34400, 'B', 220);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34500, 'B', 221);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34600, 'B', 222);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34700, 'B', 223);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34800, 'B', 224);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34900, 'B', 225);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35000, 'B', 226);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35100, 'B', 227);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35200, 'B', 228);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35300, 'B', 229);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35400, 'B', 230);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35500, 'B', 231);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35600, 'B', 232);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35700, 'B', 233);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35800, 'B', 234);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35900, 'B', 235);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36000, 'B', 236);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36100, 'B', 237);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36200, 'B', 238);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36300, 'B', 239);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36400, 'B', 240);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36500, 'B', 241);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36600, 'B', 242);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36700, 'B', 243);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36800, 'B', 244);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36900, 'B', 245);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37000, 'B', 246);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37100, 'B', 247);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37200, 'B', 248);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37300, 'B', 249);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37400, 'B', 250);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37500, 'B', 251);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37600, 'B', 252);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37700, 'B', 253);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37800, 'B', 254);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37900, 'B', 255);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38000, 'B', 256);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38100, 'B', 257);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38200, 'B', 258);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38300, 'B', 259);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38400, 'B', 260);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38500, 'B', 261);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38600, 'B', 262);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38700, 'B', 263);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38800, 'B', 264);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38900, 'B', 265);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39000, 'B', 266);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39100, 'B', 267);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39200, 'B', 268);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39300, 'B', 269);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39400, 'B', 270);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39500, 'B', 271);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39600, 'B', 272);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39700, 'B', 273);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39800, 'B', 274);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39900, 'B', 275);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40000, 'B', 276);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40100, 'B', 277);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40200, 'B', 278);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40300, 'B', 279);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40400, 'B', 280);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40500, 'B', 281);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40600, 'B', 282);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40700, 'B', 283);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40800, 'B', 284);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40900, 'B', 285);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41000, 'B', 286);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41100, 'B', 287);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41200, 'B', 288);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41300, 'B', 289);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41400, 'B', 290);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41500, 'B', 291);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41600, 'B', 292);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41700, 'B', 293);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41800, 'B', 294);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41900, 'B', 295);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42000, 'B', 296);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42100, 'B', 297);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42200, 'B', 298);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42300, 'B', 299);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42400, 'B', 300);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42500, 'B', 301);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42600, 'B', 302);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42700, 'B', 303);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42800, 'B', 304);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42900, 'B', 305);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43000, 'B', 306);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43100, 'B', 307);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43200, 'B', 308);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43300, 'B', 309);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43400, 'B', 310);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43500, 'B', 311);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43600, 'B', 312);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43700, 'B', 313);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43800, 'B', 314);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43900, 'B', 315);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44000, 'B', 316);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44100, 'B', 317);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44200, 'B', 318);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44300, 'B', 319);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44400, 'B', 320);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44500, 'B', 321);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44600, 'B', 322);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44700, 'B', 323);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44800, 'B', 324);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44900, 'B', 325);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45000, 'B', 326);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45100, 'B', 327);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45200, 'B', 328);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45300, 'B', 329);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45400, 'B', 330);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45500, 'B', 331);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45600, 'B', 332);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45700, 'B', 333);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45800, 'B', 334);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45900, 'B', 335);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46000, 'B', 336);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46100, 'B', 337);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46200, 'B', 338);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46300, 'B', 339);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46400, 'B', 340);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46500, 'B', 341);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46600, 'B', 342);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46700, 'B', 343);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46800, 'B', 344);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46900, 'B', 345);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47000, 'B', 346);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47100, 'B', 347);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47200, 'B', 348);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47300, 'B', 349);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47400, 'B', 350);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47500, 'B', 351);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47600, 'B', 352);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47700, 'B', 353);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47800, 'B', 354);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47900, 'B', 355);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48000, 'B', 356);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48100, 'B', 357);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48200, 'B', 358);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48300, 'B', 359);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48400, 'B', 360);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48500, 'B', 361);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48600, 'B', 362);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48700, 'B', 363);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48800, 'B', 364);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48900, 'B', 365);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49000, 'B', 366);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49100, 'B', 367);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49200, 'B', 368);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49300, 'B', 369);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49400, 'B', 370);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49500, 'B', 371);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49600, 'B', 372);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49700, 'B', 373);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49800, 'B', 374);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49900, 'B', 375);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50000, 'B', 376);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50100, 'B', 377);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50200, 'B', 378);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50300, 'B', 379);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50400, 'B', 380);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50500, 'B', 381);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50600, 'B', 382);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50700, 'B', 383);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50800, 'B', 384);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50900, 'B', 385);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51000, 'B', 386);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51100, 'B', 387);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51200, 'B', 388);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51300, 'B', 389);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51400, 'B', 390);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51500, 'B', 391);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51600, 'B', 392);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51700, 'B', 393);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51800, 'B', 394);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51900, 'B', 395);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52000, 'B', 396);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52100, 'B', 397);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52200, 'B', 398);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52300, 'B', 399);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52400, 'B', 400);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52500, 'B', 401);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52600, 'B', 402);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52700, 'B', 403);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52800, 'B', 404);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52900, 'B', 405);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53000, 'B', 406);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53100, 'B', 407);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53200, 'B', 408);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53300, 'B', 409);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53400, 'B', 410);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53500, 'B', 411);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53600, 'B', 412);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53700, 'B', 413);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53800, 'B', 414);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53900, 'B', 415);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54000, 'B', 416);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54100, 'B', 417);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54200, 'B', 418);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54300, 'B', 419);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54400, 'B', 420);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54500, 'B', 421);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54600, 'B', 422);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54700, 'B', 423);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54800, 'B', 424);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54900, 'B', 425);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55000, 'B', 426);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55100, 'B', 427);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55200, 'B', 428);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55300, 'B', 429);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55400, 'B', 430);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55500, 'B', 431);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55600, 'B', 432);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55700, 'B', 433);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55800, 'B', 434);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55900, 'B', 435);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56000, 'B', 436);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56100, 'B', 437);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56200, 'B', 438);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56300, 'B', 439);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56400, 'B', 440);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56500, 'B', 441);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56600, 'B', 442);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56700, 'B', 443);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56800, 'B', 444);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56900, 'B', 445);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57000, 'B', 446);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57100, 'B', 447);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57200, 'B', 448);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57300, 'B', 449);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57400, 'B', 450);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57500, 'B', 451);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57600, 'B', 452);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57700, 'B', 453);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57800, 'B', 454);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57900, 'B', 455);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58000, 'B', 456);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58100, 'B', 457);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58200, 'B', 458);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58300, 'B', 459);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58400, 'B', 460);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58500, 'B', 461);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58600, 'B', 462);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58700, 'B', 463);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58800, 'B', 464);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58900, 'B', 465);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59000, 'B', 466);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59100, 'B', 467);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59200, 'B', 468);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59300, 'B', 469);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59400, 'B', 470);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59500, 'B', 471);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59600, 'B', 472);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59700, 'B', 473);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59800, 'B', 474);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59900, 'B', 475);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60000, 'B', 476);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60100, 'B', 477);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60200, 'B', 478);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60300, 'B', 479);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60400, 'B', 480);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60500, 'B', 481);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60600, 'B', 482);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60700, 'B', 483);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60800, 'B', 484);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60900, 'B', 485);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61000, 'B', 486);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61100, 'B', 487);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61200, 'B', 488);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61300, 'B', 489);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61400, 'B', 490);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61500, 'B', 491);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61600, 'B', 492);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61700, 'B', 493);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61800, 'B', 494);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61900, 'B', 495);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62000, 'B', 496);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62100, 'B', 497);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62200, 'B', 498);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62300, 'B', 499);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62400, 'B', 500);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62500, 'B', 501);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62600, 'B', 502);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62700, 'B', 503);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62800, 'B', 504);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62900, 'B', 505);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63000, 'B', 506);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63100, 'B', 507);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63200, 'B', 508);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63300, 'B', 509);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63400, 'B', 510);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63500, 'B', 511);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63600, 'B', 512);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63700, 'B', 513);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63800, 'B', 514);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63900, 'B', 515);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64000, 'B', 516);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64100, 'B', 517);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64200, 'B', 518);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64300, 'B', 519);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64400, 'B', 520);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64500, 'B', 521);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64600, 'B', 522);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64700, 'B', 523);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64800, 'B', 524);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64900, 'B', 525);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65000, 'B', 526);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65100, 'B', 527);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65200, 'B', 528);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65300, 'B', 529);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65400, 'B', 530);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65500, 'B', 531);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65600, 'B', 532);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65700, 'B', 533);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65800, 'B', 534);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65900, 'B', 535);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66000, 'B', 536);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66100, 'B', 537);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66200, 'B', 538);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66300, 'B', 539);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66400, 'B', 540);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66500, 'B', 541);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66600, 'B', 542);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66700, 'B', 543);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66800, 'B', 544);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66900, 'B', 545);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67000, 'B', 546);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67100, 'B', 547);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67200, 'B', 548);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67300, 'B', 549);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67400, 'B', 550);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67500, 'B', 551);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67600, 'B', 552);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67700, 'B', 553);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67800, 'B', 554);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67900, 'B', 555);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68000, 'B', 556);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68100, 'B', 557);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68200, 'B', 558);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68300, 'B', 559);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68400, 'B', 560);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68500, 'B', 561);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68600, 'B', 562);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68700, 'B', 563);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68800, 'B', 564);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68900, 'B', 565);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69000, 'B', 566);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69100, 'B', 567);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69200, 'B', 568);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69300, 'B', 569);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69400, 'B', 570);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69500, 'B', 571);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69600, 'B', 572);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69700, 'B', 573);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69800, 'B', 574);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69900, 'B', 575);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70000, 'B', 576);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70100, 'B', 577);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70200, 'B', 578);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70300, 'B', 579);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70400, 'B', 580);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70500, 'B', 581);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70600, 'B', 582);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70700, 'B', 583);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70800, 'B', 584);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70900, 'B', 585);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71000, 'B', 586);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71100, 'B', 587);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71200, 'B', 588);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71300, 'B', 589);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71400, 'B', 590);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71500, 'B', 591);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71600, 'B', 592);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71700, 'B', 593);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71800, 'B', 594);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71900, 'B', 595);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72000, 'B', 596);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72100, 'B', 597);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72200, 'B', 598);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72300, 'B', 599);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72400, 'B', 600);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72500, 'B', 601);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72600, 'B', 602);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72700, 'B', 603);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72800, 'B', 604);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72900, 'B', 605);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73000, 'B', 606);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73100, 'B', 607);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73200, 'B', 608);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73300, 'B', 609);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73400, 'B', 610);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73500, 'B', 611);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73600, 'B', 612);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73700, 'B', 613);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73800, 'B', 614);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73900, 'B', 615);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74000, 'B', 616);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74100, 'B', 617);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74200, 'B', 618);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74300, 'B', 619);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74400, 'B', 620);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74500, 'B', 621);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74600, 'B', 622);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74700, 'B', 623);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74800, 'B', 624);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74900, 'B', 625);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75000, 'B', 626);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75100, 'B', 627);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75200, 'B', 628);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75300, 'B', 629);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75400, 'B', 630);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75500, 'B', 631);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75600, 'B', 632);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75700, 'B', 633);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75800, 'B', 634);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75900, 'B', 635);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76000, 'B', 636);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76100, 'B', 637);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76200, 'B', 638);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76300, 'B', 639);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76400, 'B', 640);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76500, 'B', 641);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76600, 'B', 642);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76700, 'B', 643);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76800, 'B', 644);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76900, 'B', 645);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77000, 'B', 646);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77100, 'B', 647);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77200, 'B', 648);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77300, 'B', 649);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77400, 'B', 650);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77500, 'B', 651);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77600, 'B', 652);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77700, 'B', 653);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77800, 'B', 654);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77900, 'B', 655);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78000, 'B', 656);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78100, 'B', 657);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78200, 'B', 658);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78300, 'B', 659);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78400, 'B', 660);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78500, 'B', 661);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78600, 'B', 662);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78700, 'B', 663);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78800, 'B', 664);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78900, 'B', 665);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79000, 'B', 666);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79100, 'B', 667);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79200, 'B', 668);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79300, 'B', 669);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79400, 'B', 670);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79500, 'B', 671);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79600, 'B', 672);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79700, 'B', 673);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79800, 'B', 674);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79900, 'B', 675);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80000, 'B', 676);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80100, 'B', 677);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80200, 'B', 678);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80300, 'B', 679);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80400, 'B', 680);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80500, 'B', 681);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80600, 'B', 682);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80700, 'B', 683);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80800, 'B', 684);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80900, 'B', 685);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81000, 'B', 686);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81100, 'B', 687);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81200, 'B', 688);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81300, 'B', 689);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81400, 'B', 690);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81500, 'B', 691);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81600, 'B', 692);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81700, 'B', 693);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81800, 'B', 694);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81900, 'B', 695);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82000, 'B', 696);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82100, 'B', 697);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82200, 'B', 698);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82300, 'B', 699);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82400, 'B', 700);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82500, 'B', 701);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82600, 'B', 702);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82700, 'B', 703);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82800, 'B', 704);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82900, 'B', 705);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83000, 'B', 706);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83100, 'B', 707);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83200, 'B', 708);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83300, 'B', 709);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83400, 'B', 710);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83500, 'B', 711);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83600, 'B', 712);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83700, 'B', 713);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83800, 'B', 714);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83900, 'B', 715);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84000, 'B', 716);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84100, 'B', 717);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84200, 'B', 718);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84300, 'B', 719);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84400, 'B', 720);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84500, 'B', 721);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84600, 'B', 722);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84700, 'B', 723);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84800, 'B', 724);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84900, 'B', 725);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85000, 'B', 726);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85100, 'B', 727);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85200, 'B', 728);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85300, 'B', 729);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85400, 'B', 730);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85500, 'B', 731);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85600, 'B', 732);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85700, 'B', 733);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85800, 'B', 734);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85900, 'B', 735);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86000, 'B', 736);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86100, 'B', 737);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86200, 'B', 738);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86300, 'B', 739);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86400, 'B', 740);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86500, 'B', 741);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86600, 'B', 742);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86700, 'B', 743);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86800, 'B', 744);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86900, 'B', 745);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 87000, 'B', 746);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 87100, 'B', 747);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 87200, 'B', 748);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 87300, 'B', 749);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 87400, 'B', 750);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 87500, 'B', 751);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 87600, 'B', 752);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 87700, 'B', 753);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 87800, 'B', 754);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 87900, 'B', 755);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 88000, 'B', 756);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 88100, 'B', 757);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 88200, 'B', 758);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 88300, 'B', 759);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 88400, 'B', 760);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 88500, 'B', 761);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 88600, 'B', 762);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 88700, 'B', 763);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 88800, 'B', 764);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 88900, 'B', 765);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 89000, 'B', 766);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 89100, 'B', 767);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 89200, 'B', 768);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 89300, 'B', 769);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 89400, 'B', 770);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 89500, 'B', 771);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 89600, 'B', 772);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 89700, 'B', 773);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 89800, 'B', 774);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 89900, 'B', 775);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 90000, 'B', 776);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 90100, 'B', 777);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 90200, 'B', 778);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 90300, 'B', 779);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 90400, 'B', 780);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 90500, 'B', 781);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 90600, 'B', 782);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 90700, 'B', 783);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 90800, 'B', 784);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 90900, 'B', 785);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 91000, 'B', 786);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 91100, 'B', 787);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 91200, 'B', 788);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 91300, 'B', 789);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 91400, 'B', 790);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 91500, 'B', 791);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 91600, 'B', 792);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 91700, 'B', 793);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 91800, 'B', 794);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 91900, 'B', 795);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 92000, 'B', 796);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 92100, 'B', 797);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 92200, 'B', 798);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 92300, 'B', 799);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 92400, 'B', 800);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 92500, 'B', 801);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 92600, 'B', 802);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 92700, 'B', 803);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 92800, 'B', 804);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 92900, 'B', 805);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 93000, 'B', 806);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 93100, 'B', 807);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 93200, 'B', 808);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 93300, 'B', 809);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 93400, 'B', 810);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 93500, 'B', 811);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 93600, 'B', 812);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 93700, 'B', 813);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 93800, 'B', 814);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 93900, 'B', 815);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 94000, 'B', 816);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 94100, 'B', 817);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 94200, 'B', 818);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 94300, 'B', 819);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 94400, 'B', 820);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 94500, 'B', 821);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 94600, 'B', 822);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 94700, 'B', 823);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 94800, 'B', 824);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 94900, 'B', 825);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 95000, 'B', 826);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 95100, 'B', 827);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 95200, 'B', 828);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 95300, 'B', 829);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 95400, 'B', 830);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 95500, 'B', 831);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 95600, 'B', 832);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 95700, 'B', 833);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 12500, 'A', 1);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 12600, 'A', 2);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 12700, 'A', 3);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 12800, 'A', 4);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 12900, 'A', 5);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13000, 'A', 6);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13100, 'A', 7);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13200, 'A', 8);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13300, 'A', 9);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13400, 'A', 10);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13500, 'A', 11);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13600, 'A', 12);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13700, 'A', 13);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13800, 'A', 14);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 13900, 'A', 15);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14000, 'A', 16);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14100, 'A', 17);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14200, 'A', 18);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14300, 'A', 19);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14400, 'A', 20);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14500, 'A', 21);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14600, 'A', 22);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14700, 'A', 23);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14800, 'A', 24);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 14900, 'A', 25);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15000, 'A', 26);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15100, 'A', 27);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15200, 'A', 28);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15300, 'A', 29);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15400, 'A', 30);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15500, 'A', 31);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15600, 'A', 32);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15700, 'A', 33);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15800, 'A', 34);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 15900, 'A', 35);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16000, 'A', 36);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16100, 'A', 37);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16200, 'A', 38);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16300, 'A', 39);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16400, 'A', 40);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16500, 'A', 41);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16600, 'A', 42);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16700, 'A', 43);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16800, 'A', 44);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 16900, 'A', 45);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17000, 'A', 46);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17100, 'A', 47);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17200, 'A', 48);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17300, 'A', 49);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17400, 'A', 50);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17500, 'A', 51);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17600, 'A', 52);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17700, 'A', 53);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17800, 'A', 54);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 17900, 'A', 55);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18000, 'A', 56);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18100, 'A', 57);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18200, 'A', 58);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18300, 'A', 59);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18400, 'A', 60);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18500, 'A', 61);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18600, 'A', 62);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18700, 'A', 63);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18800, 'A', 64);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 18900, 'A', 65);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19000, 'A', 66);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19100, 'A', 67);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19200, 'A', 68);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19300, 'A', 69);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19400, 'A', 70);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19500, 'A', 71);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19600, 'A', 72);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19700, 'A', 73);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19800, 'A', 74);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 19900, 'A', 75);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20000, 'A', 76);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20100, 'A', 77);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20200, 'A', 78);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20300, 'A', 79);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20400, 'A', 80);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20500, 'A', 81);
commit;
prompt 1000 records committed...
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20600, 'A', 82);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20700, 'A', 83);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20800, 'A', 84);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 20900, 'A', 85);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21000, 'A', 86);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21100, 'A', 87);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21200, 'A', 88);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21300, 'A', 89);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21400, 'A', 90);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21500, 'A', 91);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21600, 'A', 92);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21700, 'A', 93);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21800, 'A', 94);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 21900, 'A', 95);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22000, 'A', 96);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22100, 'A', 97);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22200, 'A', 98);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22300, 'A', 99);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22400, 'A', 100);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22500, 'A', 101);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22600, 'A', 102);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22700, 'A', 103);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22800, 'A', 104);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 22900, 'A', 105);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23000, 'A', 106);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23100, 'A', 107);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23200, 'A', 108);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23300, 'A', 109);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23400, 'A', 110);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23500, 'A', 111);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23600, 'A', 112);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23700, 'A', 113);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23800, 'A', 114);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 23900, 'A', 115);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24000, 'A', 116);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24100, 'A', 117);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24200, 'A', 118);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24300, 'A', 119);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24400, 'A', 120);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24500, 'A', 121);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24600, 'A', 122);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24700, 'A', 123);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24800, 'A', 124);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 24900, 'A', 125);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25000, 'A', 126);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25100, 'A', 127);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25200, 'A', 128);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25300, 'A', 129);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25400, 'A', 130);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25500, 'A', 131);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25600, 'A', 132);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25700, 'A', 133);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25800, 'A', 134);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 25900, 'A', 135);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26000, 'A', 136);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26100, 'A', 137);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26200, 'A', 138);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26300, 'A', 139);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26400, 'A', 140);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26500, 'A', 141);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26600, 'A', 142);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26700, 'A', 143);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26800, 'A', 144);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 26900, 'A', 145);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27000, 'A', 146);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27100, 'A', 147);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27200, 'A', 148);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27300, 'A', 149);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27400, 'A', 150);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27500, 'A', 151);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27600, 'A', 152);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27700, 'A', 153);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27800, 'A', 154);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 27900, 'A', 155);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28000, 'A', 156);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28100, 'A', 157);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28200, 'A', 158);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28300, 'A', 159);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28400, 'A', 160);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28500, 'A', 161);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28600, 'A', 162);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28700, 'A', 163);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28800, 'A', 164);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 28900, 'A', 165);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29000, 'A', 166);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29100, 'A', 167);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29200, 'A', 168);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29300, 'A', 169);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29400, 'A', 170);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29500, 'A', 171);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29600, 'A', 172);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29700, 'A', 173);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29800, 'A', 174);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 29900, 'A', 175);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30000, 'A', 176);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30100, 'A', 177);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30200, 'A', 178);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30300, 'A', 179);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30400, 'A', 180);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30500, 'A', 181);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30600, 'A', 182);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30700, 'A', 183);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30800, 'A', 184);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 30900, 'A', 185);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31000, 'A', 186);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31100, 'A', 187);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31200, 'A', 188);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31300, 'A', 189);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31400, 'A', 190);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31500, 'A', 191);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31600, 'A', 192);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31700, 'A', 193);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31800, 'A', 194);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 31900, 'A', 195);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32000, 'A', 196);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32100, 'A', 197);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32200, 'A', 198);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32300, 'A', 199);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32400, 'A', 200);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32500, 'A', 201);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32600, 'A', 202);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32700, 'A', 203);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32800, 'A', 204);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 32900, 'A', 205);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33000, 'A', 206);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33100, 'A', 207);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33200, 'A', 208);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33300, 'A', 209);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33400, 'A', 210);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33500, 'A', 211);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33600, 'A', 212);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33700, 'A', 213);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33800, 'A', 214);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 33900, 'A', 215);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34000, 'A', 216);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34100, 'A', 217);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34200, 'A', 218);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34300, 'A', 219);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34400, 'A', 220);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34500, 'A', 221);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34600, 'A', 222);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34700, 'A', 223);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34800, 'A', 224);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 34900, 'A', 225);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35000, 'A', 226);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35100, 'A', 227);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35200, 'A', 228);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35300, 'A', 229);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35400, 'A', 230);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35500, 'A', 231);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35600, 'A', 232);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35700, 'A', 233);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35800, 'A', 234);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 35900, 'A', 235);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36000, 'A', 236);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36100, 'A', 237);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36200, 'A', 238);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36300, 'A', 239);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36400, 'A', 240);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36500, 'A', 241);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36600, 'A', 242);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36700, 'A', 243);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36800, 'A', 244);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 36900, 'A', 245);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37000, 'A', 246);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37100, 'A', 247);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37200, 'A', 248);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37300, 'A', 249);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37400, 'A', 250);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37500, 'A', 251);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37600, 'A', 252);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37700, 'A', 253);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37800, 'A', 254);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 37900, 'A', 255);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38000, 'A', 256);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38100, 'A', 257);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38200, 'A', 258);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38300, 'A', 259);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38400, 'A', 260);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38500, 'A', 261);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38600, 'A', 262);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38700, 'A', 263);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38800, 'A', 264);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 38900, 'A', 265);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39000, 'A', 266);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39100, 'A', 267);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39200, 'A', 268);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39300, 'A', 269);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39400, 'A', 270);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39500, 'A', 271);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39600, 'A', 272);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39700, 'A', 273);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39800, 'A', 274);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 39900, 'A', 275);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40000, 'A', 276);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40100, 'A', 277);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40200, 'A', 278);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40300, 'A', 279);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40400, 'A', 280);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40500, 'A', 281);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40600, 'A', 282);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40700, 'A', 283);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40800, 'A', 284);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 40900, 'A', 285);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41000, 'A', 286);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41100, 'A', 287);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41200, 'A', 288);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41300, 'A', 289);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41400, 'A', 290);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41500, 'A', 291);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41600, 'A', 292);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41700, 'A', 293);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41800, 'A', 294);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 41900, 'A', 295);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42000, 'A', 296);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42100, 'A', 297);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42200, 'A', 298);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42300, 'A', 299);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42400, 'A', 300);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42500, 'A', 301);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42600, 'A', 302);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42700, 'A', 303);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42800, 'A', 304);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 42900, 'A', 305);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43000, 'A', 306);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43100, 'A', 307);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43200, 'A', 308);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43300, 'A', 309);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43400, 'A', 310);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43500, 'A', 311);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43600, 'A', 312);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43700, 'A', 313);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43800, 'A', 314);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 43900, 'A', 315);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44000, 'A', 316);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44100, 'A', 317);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44200, 'A', 318);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44300, 'A', 319);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44400, 'A', 320);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44500, 'A', 321);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44600, 'A', 322);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44700, 'A', 323);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44800, 'A', 324);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 44900, 'A', 325);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45000, 'A', 326);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45100, 'A', 327);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45200, 'A', 328);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45300, 'A', 329);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45400, 'A', 330);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45500, 'A', 331);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45600, 'A', 332);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45700, 'A', 333);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45800, 'A', 334);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 45900, 'A', 335);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46000, 'A', 336);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46100, 'A', 337);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46200, 'A', 338);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46300, 'A', 339);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46400, 'A', 340);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46500, 'A', 341);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46600, 'A', 342);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46700, 'A', 343);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46800, 'A', 344);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 46900, 'A', 345);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47000, 'A', 346);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47100, 'A', 347);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47200, 'A', 348);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47300, 'A', 349);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47400, 'A', 350);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47500, 'A', 351);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47600, 'A', 352);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47700, 'A', 353);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47800, 'A', 354);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 47900, 'A', 355);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48000, 'A', 356);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48100, 'A', 357);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48200, 'A', 358);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48300, 'A', 359);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48400, 'A', 360);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48500, 'A', 361);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48600, 'A', 362);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48700, 'A', 363);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48800, 'A', 364);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 48900, 'A', 365);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49000, 'A', 366);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49100, 'A', 367);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49200, 'A', 368);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49300, 'A', 369);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49400, 'A', 370);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49500, 'A', 371);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49600, 'A', 372);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49700, 'A', 373);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49800, 'A', 374);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 49900, 'A', 375);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50000, 'A', 376);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50100, 'A', 377);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50200, 'A', 378);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50300, 'A', 379);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50400, 'A', 380);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50500, 'A', 381);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50600, 'A', 382);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50700, 'A', 383);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50800, 'A', 384);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 50900, 'A', 385);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51000, 'A', 386);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51100, 'A', 387);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51200, 'A', 388);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51300, 'A', 389);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51400, 'A', 390);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51500, 'A', 391);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51600, 'A', 392);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51700, 'A', 393);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51800, 'A', 394);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 51900, 'A', 395);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52000, 'A', 396);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52100, 'A', 397);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52200, 'A', 398);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52300, 'A', 399);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52400, 'A', 400);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52500, 'A', 401);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52600, 'A', 402);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52700, 'A', 403);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52800, 'A', 404);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 52900, 'A', 405);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53000, 'A', 406);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53100, 'A', 407);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53200, 'A', 408);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53300, 'A', 409);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53400, 'A', 410);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53500, 'A', 411);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53600, 'A', 412);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53700, 'A', 413);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53800, 'A', 414);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53900, 'A', 415);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54000, 'A', 416);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54100, 'A', 417);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54200, 'A', 418);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54300, 'A', 419);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54400, 'A', 420);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54500, 'A', 421);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54600, 'A', 422);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54700, 'A', 423);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54800, 'A', 424);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54900, 'A', 425);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55000, 'A', 426);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55100, 'A', 427);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55200, 'A', 428);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55300, 'A', 429);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55400, 'A', 430);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55500, 'A', 431);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55600, 'A', 432);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55700, 'A', 433);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55800, 'A', 434);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 55900, 'A', 435);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56000, 'A', 436);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56100, 'A', 437);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56200, 'A', 438);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56300, 'A', 439);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56400, 'A', 440);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56500, 'A', 441);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56600, 'A', 442);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56700, 'A', 443);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56800, 'A', 444);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56900, 'A', 445);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57000, 'A', 446);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57100, 'A', 447);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57200, 'A', 448);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57300, 'A', 449);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57400, 'A', 450);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57500, 'A', 451);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57600, 'A', 452);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57700, 'A', 453);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57800, 'A', 454);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57900, 'A', 455);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58000, 'A', 456);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58100, 'A', 457);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58200, 'A', 458);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58300, 'A', 459);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58400, 'A', 460);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58500, 'A', 461);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58600, 'A', 462);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58700, 'A', 463);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58800, 'A', 464);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 58900, 'A', 465);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59000, 'A', 466);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59100, 'A', 467);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59200, 'A', 468);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59300, 'A', 469);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59400, 'A', 470);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59500, 'A', 471);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59600, 'A', 472);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59700, 'A', 473);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59800, 'A', 474);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59900, 'A', 475);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60000, 'A', 476);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60100, 'A', 477);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60200, 'A', 478);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60300, 'A', 479);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60400, 'A', 480);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60500, 'A', 481);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60600, 'A', 482);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60700, 'A', 483);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60800, 'A', 484);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60900, 'A', 485);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61000, 'A', 486);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61100, 'A', 487);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61200, 'A', 488);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61300, 'A', 489);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61400, 'A', 490);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61500, 'A', 491);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61600, 'A', 492);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61700, 'A', 493);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61800, 'A', 494);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 61900, 'A', 495);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62000, 'A', 496);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62100, 'A', 497);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62200, 'A', 498);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62300, 'A', 499);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62400, 'A', 500);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62500, 'A', 501);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62600, 'A', 502);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62700, 'A', 503);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62800, 'A', 504);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62900, 'A', 505);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63000, 'A', 506);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63100, 'A', 507);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63200, 'A', 508);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63300, 'A', 509);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63400, 'A', 510);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63500, 'A', 511);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63600, 'A', 512);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63700, 'A', 513);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63800, 'A', 514);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63900, 'A', 515);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64000, 'A', 516);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64100, 'A', 517);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64200, 'A', 518);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64300, 'A', 519);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64400, 'A', 520);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64500, 'A', 521);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64600, 'A', 522);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64700, 'A', 523);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64800, 'A', 524);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 64900, 'A', 525);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65000, 'A', 526);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65100, 'A', 527);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65200, 'A', 528);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65300, 'A', 529);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65400, 'A', 530);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65500, 'A', 531);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65600, 'A', 532);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65700, 'A', 533);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65800, 'A', 534);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65900, 'A', 535);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66000, 'A', 536);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66100, 'A', 537);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66200, 'A', 538);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66300, 'A', 539);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66400, 'A', 540);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66500, 'A', 541);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66600, 'A', 542);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66700, 'A', 543);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66800, 'A', 544);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66900, 'A', 545);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67000, 'A', 546);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67100, 'A', 547);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67200, 'A', 548);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67300, 'A', 549);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67400, 'A', 550);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67500, 'A', 551);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67600, 'A', 552);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67700, 'A', 553);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67800, 'A', 554);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 67900, 'A', 555);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68000, 'A', 556);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68100, 'A', 557);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68200, 'A', 558);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68300, 'A', 559);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68400, 'A', 560);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68500, 'A', 561);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68600, 'A', 562);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68700, 'A', 563);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68800, 'A', 564);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68900, 'A', 565);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69000, 'A', 566);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69100, 'A', 567);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69200, 'A', 568);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69300, 'A', 569);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69400, 'A', 570);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69500, 'A', 571);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69600, 'A', 572);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69700, 'A', 573);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69800, 'A', 574);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 69900, 'A', 575);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70000, 'A', 576);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70100, 'A', 577);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70200, 'A', 578);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70300, 'A', 579);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70400, 'A', 580);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70500, 'A', 581);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70600, 'A', 582);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70700, 'A', 583);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70800, 'A', 584);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 70900, 'A', 585);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71000, 'A', 586);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71100, 'A', 587);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71200, 'A', 588);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71300, 'A', 589);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71400, 'A', 590);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71500, 'A', 591);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71600, 'A', 592);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71700, 'A', 593);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71800, 'A', 594);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 71900, 'A', 595);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72000, 'A', 596);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72100, 'A', 597);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72200, 'A', 598);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72300, 'A', 599);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72400, 'A', 600);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72500, 'A', 601);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72600, 'A', 602);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72700, 'A', 603);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72800, 'A', 604);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 72900, 'A', 605);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73000, 'A', 606);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73100, 'A', 607);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73200, 'A', 608);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73300, 'A', 609);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73400, 'A', 610);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73500, 'A', 611);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73600, 'A', 612);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73700, 'A', 613);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73800, 'A', 614);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 73900, 'A', 615);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74000, 'A', 616);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74100, 'A', 617);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74200, 'A', 618);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74300, 'A', 619);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74400, 'A', 620);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74500, 'A', 621);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74600, 'A', 622);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74700, 'A', 623);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74800, 'A', 624);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 74900, 'A', 625);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75000, 'A', 626);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75100, 'A', 627);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75200, 'A', 628);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75300, 'A', 629);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75400, 'A', 630);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75500, 'A', 631);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75600, 'A', 632);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75700, 'A', 633);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75800, 'A', 634);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 75900, 'A', 635);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76000, 'A', 636);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76100, 'A', 637);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76200, 'A', 638);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76300, 'A', 639);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76400, 'A', 640);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76500, 'A', 641);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76600, 'A', 642);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76700, 'A', 643);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76800, 'A', 644);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 76900, 'A', 645);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77000, 'A', 646);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77100, 'A', 647);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77200, 'A', 648);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77300, 'A', 649);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77400, 'A', 650);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77500, 'A', 651);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77600, 'A', 652);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77700, 'A', 653);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77800, 'A', 654);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 77900, 'A', 655);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78000, 'A', 656);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78100, 'A', 657);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78200, 'A', 658);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78300, 'A', 659);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78400, 'A', 660);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78500, 'A', 661);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78600, 'A', 662);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78700, 'A', 663);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78800, 'A', 664);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 78900, 'A', 665);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79000, 'A', 666);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79100, 'A', 667);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79200, 'A', 668);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79300, 'A', 669);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79400, 'A', 670);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79500, 'A', 671);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79600, 'A', 672);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79700, 'A', 673);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79800, 'A', 674);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 79900, 'A', 675);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80000, 'A', 676);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80100, 'A', 677);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80200, 'A', 678);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80300, 'A', 679);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80400, 'A', 680);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80500, 'A', 681);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80600, 'A', 682);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80700, 'A', 683);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80800, 'A', 684);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 80900, 'A', 685);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81000, 'A', 686);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81100, 'A', 687);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81200, 'A', 688);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81300, 'A', 689);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81400, 'A', 690);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81500, 'A', 691);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81600, 'A', 692);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81700, 'A', 693);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81800, 'A', 694);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 81900, 'A', 695);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82000, 'A', 696);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82100, 'A', 697);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82200, 'A', 698);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82300, 'A', 699);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82400, 'A', 700);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82500, 'A', 701);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82600, 'A', 702);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82700, 'A', 703);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82800, 'A', 704);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 82900, 'A', 705);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83000, 'A', 706);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83100, 'A', 707);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83200, 'A', 708);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83300, 'A', 709);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83400, 'A', 710);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83500, 'A', 711);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83600, 'A', 712);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83700, 'A', 713);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83800, 'A', 714);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 83900, 'A', 715);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84000, 'A', 716);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84100, 'A', 717);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84200, 'A', 718);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84300, 'A', 719);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84400, 'A', 720);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84500, 'A', 721);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84600, 'A', 722);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84700, 'A', 723);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84800, 'A', 724);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 84900, 'A', 725);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85000, 'A', 726);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85100, 'A', 727);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85200, 'A', 728);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85300, 'A', 729);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85400, 'A', 730);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85500, 'A', 731);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85600, 'A', 732);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85700, 'A', 733);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85800, 'A', 734);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 85900, 'A', 735);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86000, 'A', 736);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86100, 'A', 737);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86200, 'A', 738);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 86300, 'A', 739);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 57706.05, 'C', 13);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 60659.37, 'C', 14);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 63612.69, 'C', 15);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 66565.45, 'C', 16);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 53769.85, 'D', 11);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 56722.59, 'D', 12);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 59673, 'D', 13);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 62625.76, 'D', 14);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 65576.18, 'D', 15);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 68528.34, 'D', 16);
insert into SCAF_LFIN_2007 (DAL, AL, SCAGLIONE, COD_SCAGLIONE, NUMERO_FASCIA)
values (to_date('01-01-2007', 'dd-mm-yyyy'), null, 54754.47, 'C', 12);
commit;
prompt 1669 records loaded
set feedback on
set define on
