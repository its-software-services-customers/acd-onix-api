
CREATE TABLE CHEQUE
(
    CHEQUE_ID                       INTEGER NOT NULL PRIMARY KEY,
    CHEQUE_DATE                     CHAR(19) NOT NULL,
    CHEQUE_NO                       TEXT NOT NULL UNIQUE,
    ENTITY_ID                       INTEGER NOT NULL,
    BANK_ID                         INTEGER NOT NULL,
    CASH_ACCT_ID                    INTEGER,
    BRANCH_BRANCH_NAME              INTEGER,
    CHEQUE_AMOUNT                   NUMERIC(12, 2) NOT NULL,    
    ISSUE_DATE                      CHAR(19) NOT NULL,
    ACCOUNT_DOC_ID                  INTEGER,
    DIRECTION                       INTEGER NOT NULL, /* 1=Receive, 2=Pay */    
    PAYEE_NAME                      TEXT,
    CHEQUE_STATUS                   INTEGER NOT NULL, /* 1=Pending, 2=Posted, 3=Cancel */ 

    CREATE_DATE CHAR(19)            NOT NULL,
    MODIFY_DATE CHAR(19)            NOT NULL,

    FOREIGN KEY(ENTITY_ID) REFERENCES ENTITY(ENTITY_ID),
    FOREIGN KEY(BANK_ID) REFERENCES MASTER_REF(MASTER_ID), 
    FOREIGN KEY(CASH_ACCT_ID) REFERENCES CASH_ACCOUNT(CASH_ACCOUNT_ID),
    FOREIGN KEY(ACCOUNT_DOC_ID) REFERENCES ACCOUNT_DOC(ACCOUNT_DOC_ID)
);

CREATE SEQUENCE CHEQUE_SEQ START 1;

ALTER TABLE CASH_ACCOUNT ADD COLUMN IS_FOR_CHEQUE CHAR(1);
UPDATE CASH_ACCOUNT SET IS_FOR_CHEQUE = 'N';

ALTER TABLE CHEQUE DROP BRANCH_BRANCH_NAME;
ALTER TABLE CHEQUE ADD COLUMN BANK_BRANCH_NAME TEXT;

CREATE SEQUENCE CHEQUE_APPROVED_SEQ START 1;

ALTER TABLE CHEQUE ADD ALLOW_NEGATIVE CHAR(1);
ALTER TABLE CHEQUE ADD APPROVED_DATE CHAR(19);
ALTER TABLE CHEQUE ADD APPROVED_SEQ INTEGER;

ALTER TABLE ACCOUNT_DOC ADD COLUMN PROJECT_ID INTEGER;
ALTER TABLE ACCOUNT_DOC ADD FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT(PROJECT_ID);

ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN PROJECT_ID INTEGER;
ALTER TABLE ACCOUNT_DOC_ITEM ADD FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT(PROJECT_ID);

ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN PO_PROJECT_ID INTEGER;
ALTER TABLE ACCOUNT_DOC_ITEM ADD FOREIGN KEY (PO_PROJECT_ID) REFERENCES PROJECT(PROJECT_ID);

ALTER TABLE ACCOUNT_DOC ADD COLUMN ACTUAL_TX_DATE CHAR(19);

ALTER TABLE ACCOUNT_DOC ADD COLUMN CASH_RECEIVE_AMT NUMERIC(12, 2);
ALTER TABLE ACCOUNT_DOC ADD COLUMN CASH_CHANGE_AMT NUMERIC(12, 2);

ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN DISCOUNT_PCT_FLAG CHAR(1);
UPDATE ACCOUNT_DOC_ITEM SET DISCOUNT_PCT_FLAG = 'N';

ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN DISCOUNT_PCT NUMERIC(12, 2);


ALTER TABLE ACCOUNT_DOC ADD COLUMN REF_WH_DOC_NO TEXT;
ALTER TABLE ACCOUNT_DOC ADD COLUMN REF_PO_NO TEXT;
ALTER TABLE ACCOUNT_DOC ADD COLUMN REF_RECEIPT_NO TEXT;

ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN REF_PO_NO TEXT;

ALTER TABLE SERVICE ADD COLUMN SERVICE_LEVEL INTEGER; /* 1=Regular, 2=Other */
UPDATE SERVICE SET SERVICE_LEVEL = '1';

ALTER TABLE CHEQUE ADD COLUMN NOTE TEXT;

CREATE TABLE ACCOUNT_DOC_DISCOUNT
(
    ACT_DOC_DISCOUNT_ID             INTEGER NOT NULL PRIMARY KEY,
    ACCOUNT_DOC_ID                  INTEGER NOT NULL,
    DISCOUNT_TYPE                   INTEGER NOT NULL,
    DISCOUNT_AMOUNT                 NUMERIC(12, 2) NOT NULL,    
    NOTE                            TEXT,

    CREATE_DATE CHAR(19)            NOT NULL,
    MODIFY_DATE CHAR(19)            NOT NULL,

    FOREIGN KEY(ACCOUNT_DOC_ID) REFERENCES ACCOUNT_DOC(ACCOUNT_DOC_ID),
    FOREIGN KEY(DISCOUNT_TYPE) REFERENCES MASTER_REF(MASTER_ID)
);

CREATE SEQUENCE ACCOUNT_DOC_DISCOUNT_SEQ START 1;

ALTER TABLE ACCOUNT_DOC_RECEIPT ADD PROJECT_ID INTEGER;
ALTER TABLE ACCOUNT_DOC_RECEIPT ADD FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT(PROJECT_ID);

ALTER TABLE ACCOUNT_DOC_RECEIPT ADD REF_PO_NO TEXT;
ALTER TABLE ACCOUNT_DOC_RECEIPT ADD FINAL_DISCOUNT NUMERIC(12, 2);
ALTER TABLE ACCOUNT_DOC_RECEIPT ADD PRICING_AMT NUMERIC(12, 2);

ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN ACTUAL_DOC_NO TEXT;
ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN ACTUAL_DOC_DATE CHAR(19);

ALTER TABLE ACCOUNT_DOC_PAYMENT ADD COLUMN CHEQUE_ID INTEGER;
ALTER TABLE ACCOUNT_DOC_PAYMENT ADD FOREIGN KEY (CHEQUE_ID) REFERENCES CHEQUE(CHEQUE_ID);

ALTER TABLE PAYMENT_CRITERIA ADD COLUMN WH_GROUP INTEGER;
ALTER TABLE PAYMENT_CRITERIA ADD FOREIGN KEY (WH_GROUP) REFERENCES MASTER_REF(MASTER_ID);

ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN WH_GROUP_CRITERIA INTEGER;
ALTER TABLE ACCOUNT_DOC_ITEM ADD FOREIGN KEY (WH_GROUP_CRITERIA) REFERENCES MASTER_REF(MASTER_ID);

ALTER TABLE CHEQUE ADD COLUMN AC_PAYEE_ONLY CHAR(1);
UPDATE CHEQUE SET AC_PAYEE_ONLY = 'Y';

ALTER TABLE ENTITY ADD COLUMN RV_TAX_TYPE TEXT;
UPDATE ENTITY SET RV_TAX_TYPE = '3';

INSERT INTO GLOBAL_VARIABLE
(GLOBAL_VARIABLE_ID, VARIABLE_NAME, VARIABLE_TYPE, VARIABLE_CATEGORY, VARIABLE_VALUE, VARIABLE_DESC, CREATE_DATE, MODIFY_DATE)
VALUES
(20, 'BALANCE_DATE_BY_CURRENT_DATE', 2, 1, 'N', 'Y=Use current date and balance date, N=Use document date as balance date', '2018/03/31 00:00:00', '2018/03/31 00:00:00');

ALTER TABLE AUXILARY_DOC ADD COLUMN PO_INVOICE_REF_TYPE INTEGER;
UPDATE AUXILARY_DOC SET PO_INVOICE_REF_TYPE = 1;

ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN PO_ITEM_ID INTEGER;
ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN PO_CRITERIA_ID INTEGER;

ALTER TABLE AUXILARY_DOC_ITEM ADD COLUMN REF_BY_ID INTEGER;
ALTER TABLE PAYMENT_CRITERIA ADD COLUMN REF_BY_ID INTEGER;

ALTER TABLE ACCOUNT_DOC ADD COLUMN CHEQUE_ID INTEGER;
ALTER TABLE ACCOUNT_DOC ADD FOREIGN KEY (CHEQUE_ID) REFERENCES CHEQUE(CHEQUE_ID);

ALTER TABLE CHEQUE ADD COLUMN CHEQUE_BANK_ID INTEGER;
ALTER TABLE CHEQUE ADD FOREIGN KEY (CHEQUE_BANK_ID) REFERENCES MASTER_REF(MASTER_ID);

ALTER TABLE ACCOUNT_DOC ADD COLUMN INVOICE_AVAILABLE_FLAG CHAR(1);
UPDATE ACCOUNT_DOC SET INVOICE_AVAILABLE_FLAG = 'N';

UPDATE ACCOUNT_DOC SET INVOICE_AVAILABLE_FLAG = 'Y';

INSERT INTO GLOBAL_VARIABLE
(GLOBAL_VARIABLE_ID, VARIABLE_NAME, VARIABLE_TYPE, VARIABLE_CATEGORY, VARIABLE_VALUE, VARIABLE_DESC, CREATE_DATE, MODIFY_DATE)
VALUES
(21, 'ALLOW_NEGATIVE_STRING', 2, 1, 'YYY', 'Bit 0=Inventory, 1=Ar/Ap, 2=Cash; Y=Allow Negative', '2018/04/08 00:00:00', '2018/04/08 00:00:00');

UPDATE CHEQUE SET ISSUE_DATE = CREATE_DATE;

ALTER TABLE ACCOUNT_DOC ADD COLUMN WH_PAY_TYPE INTEGER;
UPDATE ACCOUNT_DOC SET WH_PAY_TYPE = 1;

ALTER TABLE INVENTORY_DOC ADD COLUMN EMPLOYEE_ID INTEGER;
UPDATE ACCOUNT_DOC SET WH_PAY_TYPE = 1;