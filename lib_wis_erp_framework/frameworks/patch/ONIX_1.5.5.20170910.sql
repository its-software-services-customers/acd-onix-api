CREATE SEQUENCE TEST_SEQ1 START 1;
CREATE SEQUENCE TEST_SEQ2 START 1;
DROP SEQUENCE TEST_SEQ1;
DROP SEQUENCE TEST_SEQ2;

ALTER TABLE COMMISSION_PROF_DETAIL ADD COLUMN SERVICE_ID INTEGER;
ALTER TABLE COMMISSION_PROF_DETAIL ADD COLUMN ITEM_ID INTEGER;
ALTER TABLE COMMISSION_PROF_DETAIL ADD COLUMN ITEM_CATEGORY INTEGER;

ALTER TABLE COMMISSION_PROF_DETAIL ADD FOREIGN KEY (SERVICE_ID) REFERENCES SERVICE(SERVICE_ID);
ALTER TABLE COMMISSION_PROF_DETAIL ADD FOREIGN KEY (ITEM_ID) REFERENCES ITEM(ITEM_ID);
ALTER TABLE COMMISSION_PROF_DETAIL ADD FOREIGN KEY (ITEM_CATEGORY) REFERENCES ITEM_CATEGORY(ITEM_CATEGORY_ID);

ALTER TABLE COMMISSION_PROFILE ADD COLUMN PRODUCT_SPECIFIC_FLAG CHAR(1);

ALTER TABLE EMPLOYEE ADD COLUMN BRANCH_ID INTEGER;
ALTER TABLE EMPLOYEE ADD FOREIGN KEY (BRANCH_ID) REFERENCES MASTER_REF(MASTER_ID);

DELETE FROM GROUP_PERMISSION;
ALTER TABLE GROUP_PERMISSION ADD COLUMN GROUP_PERMISSION_ID INTEGER PRIMARY KEY;
CREATE SEQUENCE GROUP_PERMISSION_SEQ START 1;

ALTER TABLE LOGIN_HISTORY ADD COLUMN LOGOUT_DATE CHAR(19);
ALTER TABLE LOGIN_HISTORY ADD COLUMN SESSION TEXT;

CREATE TABLE CYCLE
(
    CYCLE_ID             INTEGER NOT NULL PRIMARY KEY,
    CYCLE_CODE           TEXT NOT NULL UNIQUE,
    CYCLE_TYPE           INTEGER NOT NULL, /* 1-weekly, 2-monthly */
    DAY_OF_MONTH         INTEGER NOT NULL, /* 1-28 if cycle_type is monthly */
    DAY_OF_WEEK          INTEGER NOT NULL, /* 0-6 if cycle_type is weekyl (0=Sunday) */
    DESCRIPTION          TEXT,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL
);

ALTER TABLE EMPLOYEE ADD COLUMN COMMISSION_CYCLE_ID INTEGER;
ALTER TABLE EMPLOYEE ADD FOREIGN KEY (COMMISSION_CYCLE_ID) REFERENCES CYCLE(CYCLE_ID);

ALTER TABLE EMPLOYEE ADD COLUMN COMMISSION_CYCLE_TYPE INTEGER;  /* 1-weekly, 2-monthly */

ALTER TABLE USER_VARIABLE DROP CONSTRAINT USER_VARIABLE_VARIABLE_NAME_KEY;
ALTER TABLE USER_VARIABLE ADD CONSTRAINT USER_VARIABLE_VARIABLE_NAME_KEY UNIQUE (VARIABLE_NAME, USER_ID);

CREATE SEQUENCE CYCLE_SEQ START 1;

ALTER TABLE CASH_DOC ADD COLUMN ALLOW_NEGATIVE CHAR(1);

ALTER TABLE INVENTORY_DOC ADD COLUMN ALLOW_NEGATIVE CHAR(1);

DROP TABLE INVENTORY_LOT;
DROP TABLE INVENTORY_BALANCE;

DROP TABLE CASH_TX;
DROP TABLE CASH_BALANCE;

DROP TABLE ITEM_PRICE;

UPDATE DOCUMENT_NUMBER SET GROUP_ID = 2 WHERE DOC_TYPE LIKE 'ACCOUNT_DOC%';

ALTER TABLE ACCOUNT_DOC ADD COLUMN BILL_SIMULATE_ID INTEGER;
ALTER TABLE ACCOUNT_DOC ADD FOREIGN KEY (BILL_SIMULATE_ID) REFERENCES BILL_SIMULATE(BILL_SIMULATE_ID);

ALTER TABLE BILL_SIMULATE ADD COLUMN SIMULATION_FLAG CHAR(1);
UPDATE BILL_SIMULATE SET SIMULATION_FLAG = 'N';

CREATE TABLE BILL_SIMULATE_DISPLAY
(
    BILL_SIM_DISPLAY_ID  INTEGER NOT NULL PRIMARY KEY,
    BILL_SIMULATE_ID     INTEGER NOT NULL,
    SELECTION_TYPE       INTEGER NOT NULL, /* 1=Service, 2=Item */
    SERVICE_ID           INTEGER NOT NULL,
    ITEM_ID              INTEGER NOT NULL,
    CODE                 TEXT NOT NULL,
    NAME                 TEXT NOT NULL,
    IS_TRAY              CHAR(1) NOT NULL,
    IS_PRICED            CHAR(1) NOT NULL,
    TOTAL_AMOUNT         NUMERIC(10, 2),
    DISCOUNT             NUMERIC(10, 2) NOT NULL,
    AMOUNT               NUMERIC(10, 2) NOT NULL,
    QUANTITY             NUMERIC(10, 2) NOT NULL,
    BASKET_TYPE          INTEGER NOT NULL,
    BUNDLE_AMOUNT        NUMERIC(10, 2) NOT NULL,
    GROUP_NO             INTEGER NOT NULL,
    PROMOTION_CODE       TEXT,
    PROMOTION_NAME       TEXT,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(BILL_SIMULATE_ID) REFERENCES BILL_SIMULATE(BILL_SIMULATE_ID),
    FOREIGN KEY(SERVICE_ID) REFERENCES SERVICE(SERVICE_ID),
    FOREIGN KEY(ITEM_ID) REFERENCES ITEM(ITEM_ID)
);

CREATE SEQUENCE BILL_SIMULATE_DISPLAY_SEQ START 1;

/* 1=ResultITem, 2=FreeItem, 3=VoucherItem, 4=PostFreeItem */
ALTER TABLE BILL_SIMULATE_DISPLAY ADD COLUMN DISPLAY_CATEGORY INTEGER NOT NULL;

ALTER TABLE BILL_SIMULATE_DISPLAY ALTER COLUMN SERVICE_ID DROP NOT NULL;
ALTER TABLE BILL_SIMULATE_DISPLAY ALTER COLUMN ITEM_ID DROP NOT NULL;

UPDATE BILL_SIMULATE SET SIMULATION_FLAG = 'Y';

ALTER TABLE ACCOUNT_DOC ADD COLUMN PROMOTION_TOTAL_AMOUNT NUMERIC(10, 2);
ALTER TABLE ACCOUNT_DOC ADD COLUMN PROMOTION_AMOUNT NUMERIC(10, 2);
ALTER TABLE ACCOUNT_DOC ADD COLUMN PROMOTION_FINAL_DISCOUNT_AMOUNT NUMERIC(10, 2);

ALTER TABLE BILL_SIMULATE_DISPLAY ADD COLUMN VOUCHER_ID INTEGER;
ALTER TABLE BILL_SIMULATE_DISPLAY ADD COLUMN FREE_TEXT TEXT;
ALTER TABLE BILL_SIMULATE_DISPLAY ADD FOREIGN KEY (VOUCHER_ID) REFERENCES VOUCHER_TEMPLATE(VOUCHER_TEMPLATE_ID);

ALTER TABLE ACCOUNT_DOC ADD COLUMN PROMO_FREE_COUNT INTEGER;
ALTER TABLE ACCOUNT_DOC ADD COLUMN PROMO_VOUCHER_COUNT INTEGER;
ALTER TABLE ACCOUNT_DOC ADD COLUMN PROMO_POSTFREE_COUNT INTEGER;


ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN VAT_TAX_FLAG CHAR(1);
ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN VAT_TAX_PCT NUMERIC(10, 2);
ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN VAT_TAX_AMT NUMERIC(10, 2);

ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN REVENUE_EXPENSE_AMT NUMERIC(10, 2);
ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN AR_AP_AMT NUMERIC(10, 2);

ALTER TABLE ACCOUNT_DOC ADD COLUMN REVENUE_EXPENSE_AMT NUMERIC(10, 2);
ALTER TABLE ACCOUNT_DOC ADD COLUMN AR_AP_AMT NUMERIC(10, 2);
ALTER TABLE ACCOUNT_DOC ADD COLUMN VAT_TYPE INTEGER; /* 1=No Vat, 2=Include, 3=Exclude */

UPDATE ACCOUNT_DOC SET VAT_TYPE = 3;

ALTER TABLE ACCOUNT_DOC ADD COLUMN ALLOW_AR_AP_NEGATIVE CHAR(1);
ALTER TABLE ACCOUNT_DOC ADD COLUMN ALLOW_CASH_NEGATIVE CHAR(1);
ALTER TABLE ACCOUNT_DOC ADD COLUMN ALLOW_INVENTORY_NEGATIVE CHAR(1);

ALTER TABLE EMPLOYEE ADD COLUMN SALESMAN_SPECIFIC_FLAG CHAR(1);

ALTER TABLE ACCOUNT_DOC ADD COLUMN APPROVED_DATE CHAR(19);
ALTER TABLE ACCOUNT_DOC ADD COLUMN APPROVED_SEQ INTEGER;

CREATE SEQUENCE ACCOUNT_DOC_APPROVED_SEQ START 1;


ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN INVENTORY_TX_ID INTEGER;
ALTER TABLE ACCOUNT_DOC_ITEM ADD FOREIGN KEY (INVENTORY_TX_ID) REFERENCES INVENTORY_TX(TX_ID);

ALTER TABLE ACCOUNT_DOC ADD COLUMN PRICING_AMT NUMERIC(10, 2);
ALTER TABLE ACCOUNT_DOC ADD COLUMN CASH_ACTUAL_RECEIPT_AMT NUMERIC(10, 2);
ALTER TABLE ACCOUNT_DOC ADD COLUMN CASH_RECEIPT_AMT NUMERIC(10, 2);

ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN FINAL_DISCOUNT_AVG NUMERIC(10, 4);


CREATE TABLE COMMISSION_BATCH
(
    COMMISSION_BATCH_ID  INTEGER NOT NULL PRIMARY KEY,
    RUN_DATE             CHAR(19) NOT NULL,
    DUE_DATE             CHAR(19) NOT NULL,
    CYCLE_TYPE           INTEGER NOT NULL,
    CYCLE_ID             INTEGER NOT NULL,
    BATCH_DESC           TEXT,
    BATCH_STATUS         INTEGER NOT NULL, /* 1=Pending, 2=Approved */
    APPROVED_DATE        CHAR(19),
    APPROVED_SEQ         INTEGER,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(CYCLE_ID) REFERENCES CYCLE(CYCLE_ID)
);

CREATE SEQUENCE COMMISSION_BATCH_SEQ START 1;


CREATE TABLE COMMISSION_BATCH_DETAIL
(
    COMMISSION_BATCH_DTL_ID INTEGER NOT NULL PRIMARY KEY,
    COMMISSION_BATCH_ID     INTEGER NOT NULL,

    EMPLOYEE_ID             INTEGER NOT NULL,
    TOTAL_BILL_COUNT        NUMERIC(10, 4) NOT NULL,
    TOTAL_BILL_AMT          NUMERIC(10, 4) NOT NULL,
    TOTAL_COMMISSION_AMT    NUMERIC(10, 4) NOT NULL,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(COMMISSION_BATCH_ID) REFERENCES COMMISSION_BATCH(COMMISSION_BATCH_ID),
    FOREIGN KEY(EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID)
);

CREATE SEQUENCE COMMISSION_BATCH_DETAIL_SEQ START 1;


CREATE TABLE COMMISSION
(
    COMMISSION_ID           INTEGER NOT NULL PRIMARY KEY,
    COMMISSION_BATCH_ID     INTEGER NOT NULL,
    EMPLOYEE_ID             INTEGER NOT NULL,
    ACCOUNT_DOC_ID          INTEGER,
    COMMISSION_AMT          NUMERIC(10, 4) NOT NULL,

    CREATE_DATE CHAR(19) NOT NULL,
    MODIFY_DATE CHAR(19) NOT NULL,

    FOREIGN KEY(COMMISSION_BATCH_ID) REFERENCES COMMISSION_BATCH(COMMISSION_BATCH_ID),
    FOREIGN KEY(EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID),
    FOREIGN KEY(ACCOUNT_DOC_ID) REFERENCES ACCOUNT_DOC(ACCOUNT_DOC_ID)
);

CREATE SEQUENCE COMMISSION_SEQ START 1;

patch_by_script_RegisterItemAndOwnerTest();

ALTER TABLE COMMISSION_BATCH ADD COLUMN DOCUMENT_NO TEXT NOT NULL UNIQUE;

patch_by_script_RegisterItemAndOwnerInventory();

patch_by_script_RegisterItemAndOwnerCash();


ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN PRIMARY_REVENUE_EXPENSE_AMT NUMERIC(12, 4);
ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN PRIMARY_ITEM_DISCOUNT_AMT NUMERIC(12, 4);
ALTER TABLE ACCOUNT_DOC_ITEM ADD COLUMN PRIMARY_FINAL_DISCOUNT_AVG_AMT NUMERIC(12, 4);

ALTER TABLE ACCOUNT_DOC ADD COLUMN PRIMARY_REVENUE_EXPENSE_AMT NUMERIC(12, 4);
ALTER TABLE ACCOUNT_DOC ADD COLUMN PRIMARY_ITEM_DISCOUNT_AMT NUMERIC(12, 4);
ALTER TABLE ACCOUNT_DOC ADD COLUMN PRIMARY_FINAL_DISCOUNT_AVG_AMT NUMERIC(12, 4);

patch_by_script_RegisterItemAndOwnerAR();

ALTER TABLE ENTITY ADD COLUMN AR_AP_BALANCE NUMERIC(12, 4);


ALTER TABLE ACCOUNT_DOC ADD COLUMN DUE_DATE CHAR(19);
ALTER TABLE ACCOUNT_DOC ADD COLUMN RECEIPT_FLAG CHAR(1);
UPDATE ACCOUNT_DOC SET RECEIPT_FLAG = 'N';

UPDATE ACCOUNT_DOC SET DUE_DATE = DOCUMENT_DATE;

CREATE SEQUENCE COMMISSION_BATCH_APPROVED_SEQ START 1;

ALTER TABLE ITEM_BARCODE ADD COLUMN BARCODE_TYPE INTEGER;
ALTER TABLE ITEM_BARCODE ADD FOREIGN KEY (BARCODE_TYPE) REFERENCES MASTER_REF(MASTER_ID);

ALTER TABLE ACCOUNT_DOC ADD COLUMN WH_TAX_PCT NUMERIC(12, 4);


INSERT INTO DOCUMENT_NUMBER
(DOCUMENT_NUMBER_ID, DOC_TYPE, LAST_RUN_YEAR, LAST_RUN_MONTH, FORMULA, RESET_CRITERIA, CURRENT_SEQ, START_SEQ, SEQ_LENGTH, YEAR_OFFSET, CREATE_DATE, MODIFY_DATE, PARENT_ID, GROUP_ID)
VALUES
(13, 'ACCOUNT_DOC_CR_TEMP', 2017, 10, '*CR-${yyyy}-${seq}', 2, 0, 1, 5, 0, '2017/10/19 00:00:00', '2017/10/19 00:00:00', 1, 1);

INSERT INTO DOCUMENT_NUMBER
(DOCUMENT_NUMBER_ID, DOC_TYPE, LAST_RUN_YEAR, LAST_RUN_MONTH, FORMULA, RESET_CRITERIA, CURRENT_SEQ, START_SEQ, SEQ_LENGTH, YEAR_OFFSET, CREATE_DATE, MODIFY_DATE, PARENT_ID, GROUP_ID)
VALUES
(14, 'ACCOUNT_DOC_CR_APPROVED', 2017, 10, 'CR-${yyyy}-${seq}', 2, 0, 1, 5, 0, '2017/10/19 00:00:00', '2017/10/19 00:00:00', 1, 1);

INSERT INTO DOCUMENT_NUMBER
(DOCUMENT_NUMBER_ID, DOC_TYPE, LAST_RUN_YEAR, LAST_RUN_MONTH, FORMULA, RESET_CRITERIA, CURRENT_SEQ, START_SEQ, SEQ_LENGTH, YEAR_OFFSET, CREATE_DATE, MODIFY_DATE, PARENT_ID, GROUP_ID)
VALUES
(15, 'ACCOUNT_DOC_DR_TEMP', 2017, 10, '*DR-${yyyy}-${seq}', 2, 0, 1, 5, 0, '2017/10/19 00:00:00', '2017/10/19 00:00:00', 1, 1);

INSERT INTO DOCUMENT_NUMBER
(DOCUMENT_NUMBER_ID, DOC_TYPE, LAST_RUN_YEAR, LAST_RUN_MONTH, FORMULA, RESET_CRITERIA, CURRENT_SEQ, START_SEQ, SEQ_LENGTH, YEAR_OFFSET, CREATE_DATE, MODIFY_DATE, PARENT_ID, GROUP_ID)
VALUES
(16, 'ACCOUNT_DOC_DR_APPROVED', 2017, 10, 'DR-${yyyy}-${seq}', 2, 0, 1, 5, 0, '2017/10/19 00:00:00', '2017/10/19 00:00:00', 1, 1);


ALTER TABLE ACCOUNT_DOC ALTER EMPLOYEE_ID DROP NOT NULL;
ALTER TABLE ACCOUNT_DOC ALTER LOCATION_ID DROP NOT NULL;

patch_by_script_CreateMissingSequences();