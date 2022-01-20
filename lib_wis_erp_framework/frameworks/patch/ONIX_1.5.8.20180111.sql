
CREATE TABLE AUXILARY_DOC
(
    AUXILARY_DOC_ID                 INTEGER NOT NULL PRIMARY KEY,
    DOCUMENT_DATE                   CHAR(19) NOT NULL,
    DELIVERY_DATE                   CHAR(19) NOT NULL,
    DOCUMENT_NO                     TEXT NOT NULL UNIQUE,
    DOCUMENT_STATUS                 INTEGER NOT NULL,
    DOCUMENT_TYPE                   INTEGER NOT NULL,
    NOTE                            TEXT,
    REF_DOC_NO                      TEXT,
    SHIFT_TO                        TEXT,
    PROJECT_ID                      INTEGER,
    ENTITY_ID                       INTEGER NOT NULL,
    ENTITY_ADDRESS_ID               INTEGER,
    BRANCH_ID                       INTEGER,
    PAYMENT_TYPE                    INTEGER,
    VAT_PERCENTAGE                  NUMERIC(12, 2) NOT NULL,
    VAT_TYPE                        INTEGER NOT NULL,
    VAT_AMT                         NUMERIC(12, 4) NOT NULL,
    WH_TAX_AMT                      NUMERIC(12, 4) NOT NULL,
    ITEM_DISCOUNT_AMT               NUMERIC(12, 4) NOT NULL,
    QUANTITY                        NUMERIC(12, 4) NOT NULL, 
    PRIMARY_REVENUE_EXPENSE_AMT     NUMERIC(12, 4) NOT NULL,
    PRIMARY_ITEM_DISCOUNT_AMT       NUMERIC(12, 4) NOT NULL, 
    PRIMARY_FINAL_DISCOUNT_AVG_AMT  NUMERIC(12, 4) NOT NULL,
    AR_AP_AMT                       NUMERIC(12, 4) NOT NULL,
    CASH_RECEIPT_AMT                NUMERIC(12, 4) NOT NULL, 
    CASH_ACTUAL_RECEIPT_AMT         NUMERIC(12, 4) NOT NULL,
    REVENUE_EXPENSE_AMT             NUMERIC(12, 4) NOT NULL,
    PRICING_AMT                     NUMERIC(12, 4) NOT NULL,
    FINAL_DISCOUNT                  NUMERIC(12, 4) NOT NULL, 

    CREATE_DATE CHAR(19)            NOT NULL,
    MODIFY_DATE CHAR(19)            NOT NULL,

    FOREIGN KEY(ENTITY_ID) REFERENCES ENTITY(ENTITY_ID),
    FOREIGN KEY(ENTITY_ADDRESS_ID) REFERENCES ENTITY_ADDRESS(ENTITY_ADDRESS_ID), 
    FOREIGN KEY(BRANCH_ID) REFERENCES MASTER_REF(MASTER_ID)
);

CREATE SEQUENCE AUXILARY_DOC_SEQ START 1;

CREATE TABLE AUXILARY_DOC_ITEM
(
    AUXILARY_DOC_ITEM_ID            INTEGER NOT NULL PRIMARY KEY,
    AUXILARY_DOC_ID                 INTEGER NOT NULL,
    SELECTION_TYPE                  INTEGER NOT NULL,
    ITEM_ID                         INTEGER,
    SERVICE_ID                      INTEGER, 
    QUANTITY                        NUMERIC(12, 2) NOT NULL,
    UNIT_PRICE                      NUMERIC(12, 4) NOT NULL,
    AMOUNT                          NUMERIC(12, 4),
    DISCOUNT_PCT                    NUMERIC(12, 4),
    DISCOUNT_AMT                    NUMERIC(12, 4),
    TOTAL_AMT                       NUMERIC(12, 4),
    TOTAL_AFTER_DISCOUNT            NUMERIC(12, 4),
    ITEM_NOTE                       TEXT,
    WH_TAX_FLAG                     CHAR(1),
    WH_TAX_PCT                      NUMERIC(12, 2),
    WH_TAX_AMT                      NUMERIC(12, 4),
    VAT_TAX_FLAG                    CHAR(1),
    VAT_TAX_AMT                     NUMERIC(12, 4),
    VAT_TAX_PCT                     NUMERIC(12, 2),
    PRIMARY_REVENUE_EXPENSE_AMT     NUMERIC(12, 4),
    PRIMARY_ITEM_DISCOUNT_AMT       NUMERIC(12, 4),
    PRIMARY_FINAL_DISCOUNT_AVG_AMT  NUMERIC(12, 4),
    REVENUE_EXPENSE_AMT             NUMERIC(12, 4),
    AR_AP_AMT                       NUMERIC(12, 4),
    FINAL_DISCOUNT_AVG              NUMERIC(12, 4),
    
    CREATE_DATE CHAR(19)            NOT NULL,
    MODIFY_DATE CHAR(19)            NOT NULL,

    FOREIGN KEY(AUXILARY_DOC_ID) REFERENCES AUXILARY_DOC(AUXILARY_DOC_ID),
    FOREIGN KEY(ITEM_ID) REFERENCES ITEM(ITEM_ID), 
    FOREIGN KEY(SERVICE_ID) REFERENCES SERVICE(SERVICE_ID)
);

CREATE SEQUENCE AUXILARY_DOC_ITEM_SEQ START 1;

INSERT INTO GLOBAL_VARIABLE
(GLOBAL_VARIABLE_ID, VARIABLE_NAME, VARIABLE_TYPE, VARIABLE_CATEGORY, VARIABLE_VALUE, VARIABLE_DESC, CREATE_DATE, MODIFY_DATE)
VALUES
(11, 'DEFAULT_VAT_TYPE_PERCHASE', 1, 1, '3', '1=Novat, 2=Include, 3=Exclude', '2018/01/11 00:00:00', '2018/01/11 00:00:00');

INSERT INTO GLOBAL_VARIABLE
(GLOBAL_VARIABLE_ID, VARIABLE_NAME, VARIABLE_TYPE, VARIABLE_CATEGORY, VARIABLE_VALUE, VARIABLE_DESC, CREATE_DATE, MODIFY_DATE)
VALUES
(12, 'DEFAULT_SELECTION_TYPE_PERCHASE', 1, 1, '1', '1=Service, 2=Item', '2018/01/11 00:00:00', '2018/01/11 00:00:00');

CREATE TABLE PROJECT
(
    PROJECT_ID                      INTEGER NOT NULL PRIMARY KEY,
    PROJECT_CODE                    TEXT NOT NULL UNIQUE,
    PROJECT_NAME                    TEXT NOT NULL,
    PROJECT_DESC                    TEXT,

    CREATE_DATE CHAR(19)            NOT NULL,
    MODIFY_DATE CHAR(19)            NOT NULL
);

CREATE SEQUENCE PROJECT_SEQ START 1;

ALTER TABLE AUXILARY_DOC ADD FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT(PROJECT_ID);

ALTER TABLE SERVICE ADD VAT_FLAG CHAR(1);
UPDATE SERVICE SET VAT_FLAG = 'N';

CREATE TABLE PAYMENT_CRITERIA
(
    PAYMENT_CRITERIA_ID             INTEGER NOT NULL PRIMARY KEY,
    DESCRIPTION                     TEXT NOT NULL,
    PERCENT                         NUMERIC(12, 2) NOT NULL,
    PAYMENT_AMT                     NUMERIC(12, 4) NOT NULL,

    CREATE_DATE CHAR(19)            NOT NULL,
    MODIFY_DATE CHAR(19)            NOT NULL
);

CREATE SEQUENCE PAYMENT_CRITERIA_SEQ START 1;

ALTER TABLE PAYMENT_CRITERIA ADD AUXILARY_DOC_ID INTEGER NOT NULL;
ALTER TABLE PAYMENT_CRITERIA ADD FOREIGN KEY (AUXILARY_DOC_ID) REFERENCES AUXILARY_DOC(AUXILARY_DOC_ID);

ALTER TABLE PROJECT ADD PROJECT_GROUP INTEGER;
ALTER TABLE PROJECT ADD FOREIGN KEY (PROJECT_GROUP) REFERENCES MASTER_REF(MASTER_ID);


CREATE TABLE VOIDED_DOCUMENT
(
    VOIDED_DOC_ID                   INTEGER NOT NULL PRIMARY KEY,
    DOCUMENT_NO                     TEXT NOT NULL,
    DOCUMENT_DATE                   CHAR(19) NOT NULL,
    NOTE                            TEXT,
    CANCEL_REASON                   INTEGER NOT NULL,
    ALLOW_AR_AP_NEGATIVE            CHAR(1) NOT NULL,
    ALLOW_INVENTORY_NEGATIVE        CHAR(1) NOT NULL,
    ALLOW_CASH_NEGATIVE             CHAR(1) NOT NULL,

    CREATE_DATE CHAR(19)            NOT NULL,
    MODIFY_DATE CHAR(19)            NOT NULL
);

CREATE SEQUENCE VOIDED_DOCUMENT_SEQ START 1;

ALTER TABLE VOIDED_DOCUMENT ADD FOREIGN KEY (CANCEL_REASON) REFERENCES MASTER_REF(MASTER_ID);

ALTER TABLE ACCOUNT_DOC ADD IS_PROMOTION_MODE CHAR(1);
UPDATE ACCOUNT_DOC SET IS_PROMOTION_MODE = 'Y';

INSERT INTO GLOBAL_VARIABLE
(GLOBAL_VARIABLE_ID, VARIABLE_NAME, VARIABLE_TYPE, VARIABLE_CATEGORY, VARIABLE_VALUE, VARIABLE_DESC, CREATE_DATE, MODIFY_DATE)
VALUES
(13, 'DEFAULT_VAT_TYPE_SALE', 1, 1, '2', '1=Novat, 2=Include, 3=Exclude', '2018/01/17 00:00:00', '2018/01/17 00:00:00');

INSERT INTO GLOBAL_VARIABLE
(GLOBAL_VARIABLE_ID, VARIABLE_NAME, VARIABLE_TYPE, VARIABLE_CATEGORY, VARIABLE_VALUE, VARIABLE_DESC, CREATE_DATE, MODIFY_DATE)
VALUES
(14, 'DEFAULT_SELECTION_TYPE_SALE', 1, 1, '2', '1=Service, 2=Item', '2018/01/17 00:00:00', '2018/01/17 00:00:00');

INSERT INTO GLOBAL_VARIABLE
(GLOBAL_VARIABLE_ID, VARIABLE_NAME, VARIABLE_TYPE, VARIABLE_CATEGORY, VARIABLE_VALUE, VARIABLE_DESC, CREATE_DATE, MODIFY_DATE)
VALUES
(15, 'COMPANY_LOGO_URL', 2, 1, 'https://host.com/image.jpg', 'URL of company logo', '2018/01/17 00:00:00', '2018/01/17 00:00:00');


CREATE TABLE ENTITY_BANK_ACCOUNT
(
    ENTITY_BACCT_ID                 INTEGER NOT NULL PRIMARY KEY,
    ENTITY_ID                       INTEGER NOT NULL, 
    BANK_ID                         INTEGER NOT NULL,    
    ACCOUNT_NO                      TEXT NOT NULL,
    ACCOUNT_NAME                    TEXT NOT NULL,
    ACCOUNT_TYPE                    INTEGER NOT NULL,
    SEQ_NO                          INTEGER NOT NULL,

    CREATE_DATE CHAR(19)            NOT NULL,
    MODIFY_DATE CHAR(19)            NOT NULL,

    FOREIGN KEY(ENTITY_ID) REFERENCES ENTITY(ENTITY_ID),
    FOREIGN KEY(BANK_ID) REFERENCES MASTER_REF(MASTER_ID),
    FOREIGN KEY(ACCOUNT_TYPE) REFERENCES MASTER_REF(MASTER_ID)
);

CREATE SEQUENCE ENTITY_BANK_ACCOUNT_SEQ START 1;

ALTER TABLE AUXILARY_DOC ADD COLUMN BANK_ACCOUNT_ID INTEGER;
ALTER TABLE AUXILARY_DOC ADD FOREIGN KEY (BANK_ACCOUNT_ID) REFERENCES ENTITY_BANK_ACCOUNT(ENTITY_BACCT_ID);

ALTER TABLE PAYMENT_CRITERIA ALTER COLUMN PAYMENT_AMT TYPE NUMERIC(12, 2);
ALTER TABLE PAYMENT_CRITERIA ADD COLUMN VAT_AMT NUMERIC(12, 2); 
ALTER TABLE PAYMENT_CRITERIA ADD COLUMN WH_TAX_AMT NUMERIC(12, 2); 

ALTER TABLE INVENTORY_DOC ADD COLUMN ADJUST_BY_DELTA_FLAG CHAR(1);
UPDATE INVENTORY_DOC SET ADJUST_BY_DELTA_FLAG = 'N';

CREATE TABLE AUXILARY_DOC_REMARK
(
    AUXILARY_DOC_REMARK_ID          INTEGER NOT NULL PRIMARY KEY,
    AUXILARY_DOC_ID                 INTEGER NOT NULL,
    CODE_REFERENCE                  TEXT,
    NOTE                            TEXT,

    CREATE_DATE CHAR(19)            NOT NULL,
    MODIFY_DATE CHAR(19)            NOT NULL,

    FOREIGN KEY (AUXILARY_DOC_ID) REFERENCES AUXILARY_DOC(AUXILARY_DOC_ID)
);

CREATE SEQUENCE AUXILARY_DOC_REMARK_SEQ START 1;

ALTER TABLE AUXILARY_DOC_REMARK ADD COLUMN EMPLOYEE_ID INTEGER;
ALTER TABLE AUXILARY_DOC_REMARK ADD COLUMN CURRENCY_ID INTEGER; 
ALTER TABLE AUXILARY_DOC_REMARK ADD COLUMN PAYMENT_TERM INTEGER; 

ALTER TABLE AUXILARY_DOC_REMARK ADD FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID);
ALTER TABLE AUXILARY_DOC_REMARK ADD FOREIGN KEY (CURRENCY_ID) REFERENCES MASTER_REF(MASTER_ID);
ALTER TABLE AUXILARY_DOC_REMARK ADD FOREIGN KEY (PAYMENT_TERM) REFERENCES MASTER_REF(MASTER_ID);

ALTER TABLE AUXILARY_DOC ADD COLUMN EMPLOYEE_ID INTEGER;
ALTER TABLE AUXILARY_DOC ADD COLUMN CURRENCY_ID INTEGER; 
ALTER TABLE AUXILARY_DOC ADD COLUMN PAYMENT_TERM INTEGER; 

ALTER TABLE AUXILARY_DOC ADD FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID);
ALTER TABLE AUXILARY_DOC ADD FOREIGN KEY (CURRENCY_ID) REFERENCES MASTER_REF(MASTER_ID);
ALTER TABLE AUXILARY_DOC ADD FOREIGN KEY (PAYMENT_TERM) REFERENCES MASTER_REF(MASTER_ID);

ALTER TABLE AUXILARY_DOC_REMARK DROP COLUMN EMPLOYEE_ID;
ALTER TABLE AUXILARY_DOC_REMARK DROP COLUMN CURRENCY_ID; 
ALTER TABLE AUXILARY_DOC_REMARK DROP COLUMN PAYMENT_TERM;

ALTER TABLE AUXILARY_DOC ADD COLUMN DAY_VALIDITY INTEGER;

ALTER TABLE AUXILARY_DOC_ITEM ALTER COLUMN DISCOUNT_AMT TYPE NUMERIC(12, 2);

ALTER TABLE AUXILARY_DOC ADD COLUMN PMT_VAT_AMT NUMERIC(12, 4);
ALTER TABLE AUXILARY_DOC ADD COLUMN PMT_VAT_INCLUDE_AMT NUMERIC(12, 4);
ALTER TABLE AUXILARY_DOC ADD COLUMN PMT_REVENUE_EXPENSE NUMERIC(12, 4);
ALTER TABLE AUXILARY_DOC ADD COLUMN PMT_REMAIN_AMT NUMERIC(12, 4);
ALTER TABLE AUXILARY_DOC ADD COLUMN PMT_WH_TAX_AMT NUMERIC(12, 4);

ALTER TABLE PAYMENT_CRITERIA ADD COLUMN VAT_INCLUDE_AMT NUMERIC(12, 4); 
ALTER TABLE PAYMENT_CRITERIA ADD COLUMN REMAIN_AMT NUMERIC(12, 4); 

ALTER TABLE PAYMENT_CRITERIA ADD COLUMN WH_PERCENT NUMERIC(12, 2); 
ALTER TABLE PAYMENT_CRITERIA ADD COLUMN VAT_PERCENT NUMERIC(12, 2); 
ALTER TABLE PAYMENT_CRITERIA ADD COLUMN MANUAL_CALCULATE_FLAG CHAR(1); 

UPDATE PAYMENT_CRITERIA SET MANUAL_CALCULATE_FLAG='Y';

ALTER TABLE SERVICE ADD COLUMN CATEGORY INTEGER; /* 0=Both, 1=Sale, 2=Purchase */
ALTER TABLE SERVICE ADD COLUMN IS_FOR_SALE CHAR(1);
ALTER TABLE SERVICE ADD COLUMN IS_FOR_PURCHASE CHAR(1);

UPDATE SERVICE SET CATEGORY = 3;
UPDATE SERVICE SET IS_FOR_SALE = 'Y';
UPDATE SERVICE SET IS_FOR_PURCHASE = 'Y';

UPDATE SERVICE SET CATEGORY = 0;

UPDATE ACCOUNT_DOC SET ARAP_PAID_OFF_FLAG = 'N';

CREATE TABLE ACCOUNT_DOC_RECEIPT
(
    ACT_DOC_RECEIPT_ID              INTEGER NOT NULL PRIMARY KEY,
    ACCOUNT_DOC_ID                  INTEGER NOT NULL,
    DOCUMENT_ID                     INTEGER NOT NULL,
    DOCUMENT_TYPE                   INTEGER NOT NULL,
    DOCUMENT_NO                     TEXT NOT NULL,
    DOCUMENT_DATE                   CHAR(19) NOT NULL,
    DUE_DATE                        CHAR(19) NOT NULL,
    AR_AP_AMT                       NUMERIC(12, 2) NOT NULL,
    WH_TAX_AMT                      NUMERIC(12, 2) NOT NULL,
    DAY_OVERDUE                     INTEGER,
    DOCUMENT_NOTE                   TEXT,

    CREATE_DATE CHAR(19)            NOT NULL,
    MODIFY_DATE CHAR(19)            NOT NULL,

    FOREIGN KEY (ACCOUNT_DOC_ID) REFERENCES ACCOUNT_DOC(ACCOUNT_DOC_ID),
    FOREIGN KEY (DOCUMENT_ID) REFERENCES ACCOUNT_DOC(ACCOUNT_DOC_ID)
);

CREATE SEQUENCE ACCOUNT_DOC_RECEIPT_SEQ START 1;

ALTER TABLE ACCOUNT_DOC ADD COLUMN INDEX_DOC_INCLUDE TEXT; 

ALTER TABLE INVENTORY_ADJUSTMENT ALTER COLUMN QUANTITY TYPE NUMERIC(14, 4);
ALTER TABLE INVENTORY_ADJUSTMENT ALTER COLUMN AMOUNT TYPE NUMERIC(14, 4);

ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN FREE_TEXT TEXT;
ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN REFERENCE_NUMBER TEXT;

ALTER TABLE EMPLOYEE ADD COLUMN EMPLOYEE_NAME_ENG TEXT;

ALTER TABLE MASTER_REF ADD COLUMN OPTIONAL TEXT;
ALTER TABLE MASTER_REF ADD COLUMN OPTIONAL_ENG TEXT;
ALTER TABLE MASTER_REF ADD COLUMN DESCRIPTION_ENG TEXT;

UPDATE MASTER_REF SET DESCRIPTION_ENG = DESCRIPTION;

ALTER TABLE AUXILARY_DOC_ITEM ADD COLUMN FREE_TEXT TEXT;

ALTER TABLE ACCOUNT_DOC ADD COLUMN RECEIPT_ID INTEGER; 
ALTER TABLE ACCOUNT_DOC ADD FOREIGN KEY (RECEIPT_ID) REFERENCES ACCOUNT_DOC(ACCOUNT_DOC_ID);


ALTER TABLE ACCOUNT_DOC_RECEIPT ADD COLUMN REVENUE_EXPENSE_AMT NUMERIC(14, 4);
ALTER TABLE ACCOUNT_DOC_RECEIPT ADD COLUMN VAT_AMT NUMERIC(14, 4);
ALTER TABLE ACCOUNT_DOC_RECEIPT ADD COLUMN CASH_RECEIPT_AMT NUMERIC(14, 4);

ALTER TABLE COMPANY_PROFILE ADD COLUMN PREFIX_ID INTEGER; 
ALTER TABLE COMPANY_PROFILE ADD FOREIGN KEY (PREFIX_ID) REFERENCES MASTER_REF(MASTER_ID);


ALTER TABLE ACCOUNT_DOC_PAYMENT ADD COLUMN CHANGE_TYPE INTEGER; /* 1=Cash, 2=Credit */
UPDATE ACCOUNT_DOC_PAYMENT SET CHANGE_TYPE = 1;

ALTER TABLE ACCOUNT_DOC ADD COLUMN CHANGE_TYPE INTEGER; /* 1=Cash, 2=Credit */
UPDATE ACCOUNT_DOC SET CHANGE_TYPE = 1;

INSERT INTO GLOBAL_VARIABLE
(GLOBAL_VARIABLE_ID, VARIABLE_NAME, VARIABLE_TYPE, VARIABLE_CATEGORY, VARIABLE_VALUE, VARIABLE_DESC, CREATE_DATE, MODIFY_DATE)
VALUES
(16, 'SALE_CASH_CHANGE_TYPE', 1, 1, '1', '1=Cash, 2=Credit', '2018/02/26 00:00:00', '2018/02/26 00:00:00');

INSERT INTO GLOBAL_VARIABLE
(GLOBAL_VARIABLE_ID, VARIABLE_NAME, VARIABLE_TYPE, VARIABLE_CATEGORY, VARIABLE_VALUE, VARIABLE_DESC, CREATE_DATE, MODIFY_DATE)
VALUES
(17, 'SALE_DEBT_CHANGE_TYPE', 1, 1, '2', '1=Cash, 2=Credit', '2018/02/26 00:00:00', '2018/02/26 00:00:00');

INSERT INTO GLOBAL_VARIABLE
(GLOBAL_VARIABLE_ID, VARIABLE_NAME, VARIABLE_TYPE, VARIABLE_CATEGORY, VARIABLE_VALUE, VARIABLE_DESC, CREATE_DATE, MODIFY_DATE)
VALUES
(18, 'PURCHASE_CASH_CHANGE_TYPE', 1, 1, '1', '1=Cash, 2=Credit', '2018/02/26 00:00:00', '2018/02/26 00:00:00');

INSERT INTO GLOBAL_VARIABLE
(GLOBAL_VARIABLE_ID, VARIABLE_NAME, VARIABLE_TYPE, VARIABLE_CATEGORY, VARIABLE_VALUE, VARIABLE_DESC, CREATE_DATE, MODIFY_DATE)
VALUES
(19, 'PURCHASE_DEBT_CHANGE_TYPE', 1, 1, '2', '1=Cash, 2=Credit', '2018/02/26 00:00:00', '2018/02/26 00:00:00');

ALTER TABLE ACCOUNT_DOC ADD COLUMN BY_VOID_FLAG CHAR(1);
UPDATE ACCOUNT_DOC SET BY_VOID_FLAG = 'Y' WHERE DOCUMENT_NO LIKE '(void)%';
UPDATE ACCOUNT_DOC SET BY_VOID_FLAG = 'N' WHERE DOCUMENT_NO NOT LIKE '(void)%';

ALTER TABLE SERVICE ADD COLUMN WH_GROUP INTEGER; 
ALTER TABLE SERVICE ADD FOREIGN KEY (WH_GROUP) REFERENCES MASTER_REF(MASTER_ID);

ALTER TABLE ACCOUNT_DOC ADD COLUMN WH_DEFINITION TEXT;

ALTER TABLE ACCOUNT_DOC_RECEIPT ADD COLUMN WH_DEFINITION TEXT;
