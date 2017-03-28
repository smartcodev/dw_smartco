ALTER TABLE SMARTCO.MIS_TF001_PORTA_BLOQUEADA 
DROP CONSTRAINT MIS_PB_TF001_PORTA_BLOQUE_FK1;

ALTER TABLE SMARTCO.MIS_TF001_PORTA_BLOQUEADA 
DROP CONSTRAINT MIS_PB_TF001_PORTA_BLOQUE_FK2;

ALTER TABLE SMARTCO.MIS_TF001_PORTA_BLOQUEADA 
DROP CONSTRAINT MIS_PB_TF001_PORTA_BLOQUE_FK3;

DROP TABLE SMARTCO.MIS_TF001_PORTA_BLOQUEADA CASCADE CONSTRAINTS;

DROP TABLE SMARTCO.MIS_TD003_LOCALIDADE CASCADE CONSTRAINTS;

DROP TABLE SMARTCO.MIS_TD001_DETALHE_BLOQ CASCADE CONSTRAINTS;

CREATE TABLE SMARTCO.MIS_TD001_DETALHE_BLOQ 
(
  ID NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL 
, PRODUTO VARCHAR2(50) 
, MOTIVO VARCHAR2(50) NOT NULL 
, SUBMOTIVO VARCHAR2(50) NOT NULL 
, DATE_FROM DATE 
, DATE_TO DATE 
, VERSION NUMBER 
, CONSTRAINT MIS_PB_TD001_DETALHE_BLOQU_PK PRIMARY KEY 
  (
    ID 
  )
  ENABLE 
);

CREATE TABLE SMARTCO.MIS_TD003_LOCALIDADE 
(
  ID NUMBER 
, ARMARIO VARCHAR2(11 BYTE) 
, REGIONAL VARCHAR2(12 BYTE) 
, CIDADE VARCHAR2(30 BYTE) 
, ESTADO VARCHAR2(2 BYTE) 
, DATE_FROM DATE 
, DATE_TO DATE 
, VERSION NUMBER 
);

CREATE TABLE SMARTCO.MIS_TF001_PORTA_BLOQUEADA 
(
  ID NUMBER GENERATED ALWAYS AS IDENTITY NOT NULL 
, ID_PORTA_VOZ VARCHAR2(50) NOT NULL 
, LOCALIDADE_FK NUMBER NOT NULL 
, DETALHE_BLOQUEIO_FK NUMBER NOT NULL 
, DATA_BLOQUEIO_FK DATE NOT NULL 
, CONSTRAINT MIS_PB_TF001_PORTA_BLOQUEA_PK PRIMARY KEY 
  (
    ID 
  )
  ENABLE 
);

CREATE BITMAP INDEX SMARTCO.IDX_MIS_TD003_LOCALIDADE_TK ON SMARTCO.MIS_TD003_LOCALIDADE (ID ASC) 
LOGGING 
TABLESPACE REPOSITORY 
PCTFREE 10 
INITRANS 2 
STORAGE 
( 
  INITIAL 4194304 
  NEXT 4194304 
  MINEXTENTS 1 
  MAXEXTENTS UNLIMITED 
  PCTINCREASE 0 
  BUFFER_POOL DEFAULT 
) 
NOPARALLEL;

CREATE INDEX SMARTCO.IDX_MIS_TD003_LOC_LOOKUP ON SMARTCO.MIS_TD003_LOCALIDADE (ARMARIO ASC) 
LOGGING 
TABLESPACE REPOSITORY 
PCTFREE 10 
INITRANS 2 
STORAGE 
( 
  INITIAL 4194304 
  NEXT 4194304 
  MINEXTENTS 1 
  MAXEXTENTS UNLIMITED 
  PCTINCREASE 0 
  BUFFER_POOL DEFAULT 
) 
NOPARALLEL;

ALTER TABLE SMARTCO.MIS_TF001_PORTA_BLOQUEADA
ADD CONSTRAINT MIS_PB_TF001_PORTA_BLOQUE_FK1 FOREIGN KEY
(
  ID 
)
REFERENCES SMARTCO.MIS_TD001_DETALHE_BLOQ
(
  ID 
)
ENABLE;

ALTER TABLE SMARTCO.MIS_TF001_PORTA_BLOQUEADA
ADD CONSTRAINT MIS_PB_TF001_PORTA_BLOQUE_FK2 FOREIGN KEY
(
  LOCALIDADE_FK 
)
REFERENCES SMARTCO.MIS_TD003_LOCALIDADE
(
  ID 
)
ENABLE;

ALTER TABLE SMARTCO.MIS_TF001_PORTA_BLOQUEADA
ADD CONSTRAINT MIS_PB_TF001_PORTA_BLOQUE_FK3 FOREIGN KEY
(
  DATA_BLOQUEIO_FK 
)
REFERENCES SMARTCO.MIS_TD002_TEMPO
(
  DAY_ID 
)
ENABLE;